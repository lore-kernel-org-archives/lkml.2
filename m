Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab2CJTxV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 14:53:21 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:52579 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317Ab2CJTxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 14:53:17 -0500
Date: Sat, 10 Mar 2012 14:53:16 -0500
From: Eric B Munson <emunson@mgebm.net>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: avi@redhat.com, mingo@redhat.com, hpa@zytor.com, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com, kvm@vger.kernel.org, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4 V13] Avoid soft lockup message when KVM is stopped by
 host
Message-ID: <20120310195316.GB6648@mgebm.net>
References: <1328713666-11424-1-git-send-email-emunson@mgebm.net>
 <20120214152931.GA6881@mgebm.net>
 <20120214153836.GA21106@amt.cnet>
 <20120214155013.GB6881@mgebm.net>
 <20120214161009.GA21515@amt.cnet>
 <20120214211720.GC6881@mgebm.net>
 <20120305163943.GA10338@amt.cnet>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wzJLGUyc3ArbnUjN"
Content-Disposition: inline
In-Reply-To: <20120305163943.GA10338@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wzJLGUyc3ArbnUjN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 05 Mar 2012, Marcelo Tosatti wrote:

> On Tue, Feb 14, 2012 at 04:17:20PM -0500, Eric B Munson wrote:
> > On Tue, 14 Feb 2012, Marcelo Tosatti wrote:
> >=20
> > > On Tue, Feb 14, 2012 at 10:50:13AM -0500, Eric B Munson wrote:
> > > > On Tue, 14 Feb 2012, Marcelo Tosatti wrote:
> > > >=20
> > > > > On Tue, Feb 14, 2012 at 10:29:31AM -0500, Eric B Munson wrote:
> > > > > > On Wed, 08 Feb 2012, Eric B Munson wrote:
> > > > > >=20
> > > > > > >=20
> > > > > > > When a guest kernel is stopped by the host hypervisor it can =
look like a soft
> > > > > > > lockup to the guest kernel.  This false warning can mask late=
r soft lockup
> > > > > > > warnings which may be real.  This patch series adds a method =
for a host
> > > > > > > hypervisor to communicate to a guest kernel that it is being =
stopped.  The
> > > > > > > final patch in the series has the watchdog check this flag wh=
en it goes to
> > > > > > > issue a soft lockup warning and skip the warning if the guest=
 knows it was
> > > > > > > stopped.
> > > > > > >=20
> > > > > > > It was attempted to solve this in Qemu, but the side effects =
of saving and
> > > > > > > restoring the clock and tsc for each vcpu put the wall clock =
of the guest behind
> > > > > > > by the amount of time of the pause.  This forces a guest to h=
ave ntp running
> > > > > > > in order to keep the wall clock accurate.
> > > > > >=20
> > > > > > Avi,
> > > > > >=20
> > > > > > Is this set fit for merging or is there something else you want=
 changed?
> > > > >=20
> > > > > Eric,
> > > > >=20
> > > > > On Message-ID: <20120210160536.GA23363@amt.cnet>, i asked:
> > > > >=20
> > > > > How is the stub getting included for other architectures again?
> > > > >=20
> > > >=20
> > > > Marcelo,
> > > >=20
> > > > Sorry, I put out V13 to answer that.  There is a stub in asm-generi=
c that was
> > > > lost in the V11-V12 rebase.  This stub has be included in the V13 s=
et.
> > > >=20
> > > > Eric
> > >=20
> > > Eric,=20
> > >=20
> > > I know the stub has been included in the series. But i am asking how=
=20
> > > it is #include'ed for other architectures? (can't see that).
> >=20
> > Marcelo,
> >=20
> > kernel/watchdog.c now includes linux/kvm_para.h which includes asm/kvm_=
para.h.
> > The check_and_clear function is defined in arch include/asm/kvm_para.h =
or in
> > asm-generic/kvm_para.h for any arch lacking the specific header in thei=
r asm
> > include dir.  If I have misunderstood how these headers work, please le=
t me
> > know and I will fix it.
>=20
> There is no automatic inclusion of asm-generic/ headers. You must create
> kvm_para.h in each architecture's include/asm/ directory, #including
> asm-generic/kvm_para.h.
>=20

Hopefully V16 handles this properly, please let me know if there is anything
that needs to be addressed.  I'd like to see this set in for the 3.4 window.

Eric

--wzJLGUyc3ArbnUjN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPW7EsAAoJEKhG9nGc1bpJh1IQAIYwatNENzqLmgtLERNStiDi
+RI5ylPy+7nNsD1Tz+dlIrp4zK/og0YfTD91acEd2mWUSYZjfeSykZHROR/xqbKU
es6Qf0ygT5r7miieGGH3u56zRjKqk8DVNbORK4DQVhQdfO6ZwY0cZF2/zY7wVnfz
JjTVD+A2AGEC3NU8skcq0ALvfwbxcuxPfrIxULT/Nqkfn+XoGVcXhOSEMlzVfUh3
CZC/Wz6N6jvUmDb/NQgAKgxNsjrshlBq6sfj15bQumOzOFkDngzxPtuH/PKJlTa1
J2mJUXAyPDa1+TlZklwT86m+7/oSqByv0RQlW5spZ8DGSNyUMigQfQIvv+BY+eKS
YcreFuTn3JTvNxyoSx7q6SKjFm57Z9HT053RuOH00v9tAlJboqsx2y8q5VcYASDH
UxOWgTRzWfG2MpUQT8bd7hAu6taKHDTJyh364Gwv7xz4AGTlo4eP+t3CYJAuRHlb
WnEnRm0Pp7ifANdq3djJOCbOT5gJEmSaJCb2trEfrGlzWEGrX7BRQBItXQCyf4c8
sKVurzqunabW+1hsXON0chh4NjEjTYCt8fl/nPMUVOCzgoclUwTz3QyVaNmHDFq/
yMPoSs1FTphVcs2c4GUpbpeFZY8GZcS48QnooSWQXF4eLcShSk6M6KRCe7lvIApc
9AnU21mrOvW6epQhseZZ
=c8bz
-----END PGP SIGNATURE-----

--wzJLGUyc3ArbnUjN--
