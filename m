Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab2BQAJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 19:09:30 -0500
Received: from ozlabs.org ([203.10.76.45]:44544 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753981Ab2BQAJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 19:09:29 -0500
Message-ID: <1329437356.6991.8.camel@concordia>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Avi Kivity <avi@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, qemu-devel@nongnu.org,
        Alexander Graf <agraf@suse.de>, KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Eric Northup <digitaleric@google.com>,
        Scott Wood <scottwood@freescale.com>
Date: Fri, 17 Feb 2012 11:09:16 +1100
In-Reply-To: <4F3D58CE.2070209@redhat.com>
References: <4F2AB552.2070909@redhat.com>
	 <1328597934.6802.6.camel@concordia>
	 <F1B17875-23E2-4965-BE05-6A3858995D21@suse.de>
	 <201202152221.36154.arnd@arndb.de> <1329354245.6976.25.camel@concordia>
	 <4F3D58CE.2070209@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-q3YQOmcmGr9ZNjsZ1ZVe"
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-q3YQOmcmGr9ZNjsZ1ZVe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-02-16 at 21:28 +0200, Avi Kivity wrote:
> On 02/16/2012 03:04 AM, Michael Ellerman wrote:
> > >=20
> > > ioctl is good for hardware devices and stuff that you want to enumera=
te
> > > and/or control permissions on. For something like KVM that is really =
a
> > > core kernel service, a syscall makes much more sense.
> >
> > Yeah maybe. That distinction is at least in part just historical.
> >
> > The first problem I see with using a syscall is that you don't need one
> > syscall for KVM, you need ~90. OK so you wouldn't do that, you'd use a
> > multiplexed syscall like epoll_ctl() - or probably several
> > (vm/vcpu/etc).
>=20
> No.  Many of our ioctls are for state save/restore - we reduce that to
> two.  Many others are due to the with/without irqchip support - we slash
> that as well.  The device assignment stuff is relegated to vfio.
>=20
> I still have to draw up a concrete proposal, but I think we'll end up
> with 10-15.

That's true, you certainly could reduce it, though by how much I'm not
sure. On powerpc I'm working on moving the irq controller emulation into
the kernel, and some associated firmware emulation, so that's at least
one new ioctl. And there will always be more, whatever scheme you have
must be easily extensible - ie. not requiring new syscalls for each new
weird platform.

> > Secondly you still need a handle/context for those syscalls, and I thin=
k
> > the most sane thing to use for that is an fd.
>=20
> The context is the process (for vm-wide calls) and thread (for vcpu
> local calls).

Yeah OK I forgot you'd mentioned that. But isn't that change basically
orthogonal to how you get into the kernel? ie. we could have the
kvm/vcpu pointers in mm_struct/task_struct today?

I guess it wouldn't win you much though because you still have the fd
and ioctl overhead as well.

cheers

--=-q3YQOmcmGr9ZNjsZ1ZVe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCAAGBQJPPZqsAAoJEFHr6jzI4aWAiT4P/jTPljge8dXZ6sgcZft90se4
7mXJiIctGyZ7cwf0pGxJBH8hSg3NLP/1hplSC1lBQMx3SvWIzo8Ch3LR1k1jwFk6
KJx+8DWjbaqncL4sxtqN3n+soT/u9QqVch7n+RxoF6gvzZiR5+lJwCS14zqyOPuq
M0HFmfsqWIu6pK+NeIIYa/29r2a3A/xgTlr//XZZoaD0tA3YPz9AqWl9+9iuw6J1
RoSElR/FBqntdU4dOKnEpPLa3YU5RxRT+4QoEpwAKboHlGMM1hipC76XTwJIL/J7
jUgd05x70NWjEpeDaEVV07KWC4hxAt76uEybf/bBcc9+EH+LVI4K7qn/v9ITw+4Q
5TZG9xSidQh1pkJ2ZP/jwMD53grGv5CNIdAIatIDxS27ufJWfG1BP+7qkJGZgjkn
sURwA16W2hzucvcnPWnhM61k8siWfwh0R6icE8Wh1evlLZxXlSQ1ADdDYP5sdT+e
1eN6MwkHtNMwUTQHd/gjlWj6pEjrkTNi4Mkzrrxzan6kJnDM8oIXmiJOFCUQmSCu
6kB/RtmJRWn6Dw9297DqvJtAGLEOgjPR6I2W2HvM0v7LdfeRGkelh1VMjkMjBAQs
aaC7QDrETa40OCP/uR5kFW9ao2F6+AY9QjsQkAAWDK0UViEfEbmiEqHXyDqn6yk+
nmzXR0MdZQUiYwjUL1U+
=hUM+
-----END PGP SIGNATURE-----

--=-q3YQOmcmGr9ZNjsZ1ZVe--

