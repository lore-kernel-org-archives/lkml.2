Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab1LAVc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 16:32:59 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:50181 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523Ab1LAVc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 16:32:58 -0500
Date: Thu, 1 Dec 2011 16:32:56 -0500
From: Eric B Munson <emunson@mgebm.net>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "ryanh@linux.vnet.ibm.com" <ryanh@linux.vnet.ibm.com>,
        "aliguori@us.ibm.com" <aliguori@us.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "avi@redhat.com" <avi@redhat.com>
Subject: Re: [PATCH] Guest stop notification
Message-ID: <20111201213256.GC8803@mgebm.net>
References: <1322602574-27072-1-git-send-email-emunson@mgebm.net>
 <4ED79138.60603@siemens.com>
 <20111201172244.GB8803@mgebm.net>
 <4ED7BB11.1050309@siemens.com>
 <20111201212503.GB25290@amt.cnet>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HG+GLK89HZ1zG0kk"
Content-Disposition: inline
In-Reply-To: <20111201212503.GB25290@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HG+GLK89HZ1zG0kk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 01 Dec 2011, Marcelo Tosatti wrote:

> On Thu, Dec 01, 2011 at 06:36:17PM +0100, Jan Kiszka wrote:
> > On 2011-12-01 18:22, Eric B Munson wrote:
> > > On Thu, 01 Dec 2011, Jan Kiszka wrote:
> > >=20
> > >> On 2011-11-29 22:36, Eric B Munson wrote:
> > >>> Often when a guest is stopped from the qemu console, it will report=
 spurious
> > >>> soft lockup warnings on resume.  There are kernel patches being dis=
cussed that
> > >>> will give the host the ability to tell the guest that it is being s=
topped and
> > >>> should ignore the soft lockup warning that generates.
> > >>>
> > >>> Signed-off-by: Eric B Munson <emunson@mgebm.net>
> > >>> Cc: ryanh@linux.vnet.ibm.com
> > >>> Cc: aliguori@us.ibm.com
> > >>> Cc: mtosatti@redhat.com
> > >>> Cc: avi@redhat.com
> > >>> Cc: kvm@vger.kernel.org
> > >>> Cc: linux-kernel@vger.kernel.org
> > >>> ---
> > >>>  target-i386/kvm.c |    6 ++++++
> > >>>  1 files changed, 6 insertions(+), 0 deletions(-)
> > >>>
> > >>> diff --git a/target-i386/kvm.c b/target-i386/kvm.c
> > >>> index 5bfc21f..defd364 100644
> > >>> --- a/target-i386/kvm.c
> > >>> +++ b/target-i386/kvm.c
> > >>> @@ -336,12 +336,18 @@ static int kvm_inject_mce_oldstyle(CPUState *=
env)
> > >>>      return 0;
> > >>>  }
> > >>> =20
> > >>> +static void kvm_put_guest_paused(CPUState *penv)
> > >>> +{
> > >>> +    kvm_vcpu_ioctl(penv, KVM_GUEST_PAUSED, 0);
> > >>> +}
> > >>
> > >> I see no need in encapsulating this in a separate function.
> > >>
> > >>> +
> > >>>  static void cpu_update_state(void *opaque, int running, RunState s=
tate)
> > >>>  {
> > >>>      CPUState *env =3D opaque;
> > >>> =20
> > >>>      if (running) {
> > >>>          env->tsc_valid =3D false;
> > >>> +	kvm_put_guest_paused(env);
> > >>
> > >> checkpatch.pl would have asked you to remove this tab.
> > >>
> > >> More general:
> > >>
> > >> Why is this x86-only? If the kernel interface is x86-only, what prev=
ents
> > >> making it generic right from the beginning?
> > >=20
> > > Sorry, missed this question on the first pass, this is x86 only becau=
se the
> > > flag used lives in the pvclock structure.  AFAICT, there aren't any o=
ther
> > > architectures out there that implement paravirtualized clocks yet.
> >=20
> > That's an implementation "detail" of the kernel. The interface (IOCTL or
> > kvm_run field) is generic, no?
> >=20
> > I would just fire this notification from generic code, evaluate the
> > error (that was lacking so far), and only report it if it's something
> > else than "not supported".
>=20
> Yes, it should live in hw/kvmclock.c preferably.
>=20

Okay, I get a V3 with this moved around out tomorrow.

Thanks for the feedback,
Eric

--HG+GLK89HZ1zG0kk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO1/KIAAoJEKhG9nGc1bpJU0QQAJo+tjto7ROA4w1b7x++lnx4
pfpdI75Gv9eY294XgLuXFvt+HLqnanZm1264+Llf9rE4VgD6w0Qf1/jPpXNQYLIO
ECrTXzc5x4iAWAXfTfrbZMmG55iXB7xzRqKvP4Pvm45pnOXDfVTuQQ/Lj2RkzWCJ
md7umf8lLGkiVIs52fgZ4EB0WF1qtmzp2wiyNRGg9BzS5fvsC+Rkf9e+Un8JUi9m
/OALmx/XkluYQvRW9Sf7J7lECHxZOzlGvMy/M98Xd5V9W8kpubXL/IN69IB5Zxth
ynm7g1mDr74AIeQrAjrxmjTHlgRghssIqDB+I/T2COCTgMC8xNjZ8y4aWn+OSV6S
ry4+ymPWvSFaIK9iK68dPNU/pSKlSBC/h9XRzOYaT4JbaJjvcQ5ETSIQEZ5J4U5z
Ke/+y+giR2EfxeheQL4gpjPbcjXyTLlekL2kVPjY73tT4ZH9L4emc/YDwJmZVCCD
rRCrrzt+G/0ni0+1AWjopdgmKIe5yHxG5RUFXM+OMu+m7zwHUFmcPstPxZhudEE5
ioM5GhVOS6C96izL48I9eTruYfd+9Nt53Ne+xwIP8hw48UsgyHkibzjkFRmEyVlG
GjyQUPhlnqfhSTJafPbmtxsbtNr8WlqPZuSgbr7x7xjfYiQB+e6bf3ZiMhlj3CSv
FA4b1tyvzEWmMj3UiR46
=ul3z
-----END PGP SIGNATURE-----

--HG+GLK89HZ1zG0kk--
