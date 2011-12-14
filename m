Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757748Ab1LNR5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 12:57:44 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:40768 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755200Ab1LNR5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 12:57:42 -0500
Date: Wed, 14 Dec 2011 12:57:40 -0500
From: Eric B Munson <emunson@mgebm.net>
To: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com,
        jeremy.fitzhardinge@citrix.com, levinsasha928@gmail.com,
        Jan Kiszka <jan.kiszka@siemens.com>, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5 V5] Add functions to check if the host has stopped
 the vm
Message-ID: <20111214175740.GC4075@mgebm.net>
References: <1323116344-17911-1-git-send-email-emunson@mgebm.net>
 <1323116344-17911-3-git-send-email-emunson@mgebm.net>
 <4EDF78C5.8060908@redhat.com>
 <20111208152310.GB6301@mgebm.net>
 <20111214121124.GA18317@amt.cnet>
 <4EE8B4AD.2060101@redhat.com>
 <20111214171105.GB4075@mgebm.net>
 <4EE8DD53.5010408@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E/DnYTRukya0zdZ1"
Content-Disposition: inline
In-Reply-To: <4EE8DD53.5010408@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E/DnYTRukya0zdZ1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Dec 2011, Avi Kivity wrote:

> On 12/14/2011 07:11 PM, Eric B Munson wrote:
> > > > >=20
> > > > > If I understand (please correct me if this is wrong) because this=
 is only
> > > > > called from the watchdog, which disables preemption, we should be=
 protected
> > > > > from something else writing to these flags.
> > > >
> > > > The host can write, but in that case race is harmless.
> > >=20
> > > Why is it harmless?  You don't know what's in those other flags.
> > >=20
> > > --=20
> > > error compiling committee.c: too many arguments to function
> > >=20
> >
> > Currently there is only one other flag in this byte (PVCLOCK_TSC_STABLE=
_BIT)
> > and it isset once in kvmclock_init().  It is highly unlikely that the v=
m will
> > be stopped during this init and have the flag clobbered.  After the tsc=
 stable
> > bit is written in the init, the field is read only outside of the guest=
 paused
> > code.
>=20
> Let's not lay minefields for us later to step into.  Making this a
> cpu-local atomic (irq safe but not smp safe) is simple and easy,
> somehting like __this_cpu_and().
>=20
> --=20
> error compiling committee.c: too many arguments to function
>=20

Fair enough, I will add this to V7.


--E/DnYTRukya0zdZ1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO6OOUAAoJEKhG9nGc1bpJfkgP/1g3S65dNm/1Zrl/P15jYwIr
vju/EmB19QMXKQd7lejjwd48eT6hm9vl7krozF8Ns4I4C51C15zX83qaK8aNL5MO
NaQg1FQN5Bk4fQBqu1VCYy4ifylqSQwz6xYtcz2CYjfIEEI8lfAdfxA9V/8PNyvr
w2LFKRNynx50H3z8JJegpbVPBdffP02UQqV0qWb3HMKSaxI89aTi/Sjt144i2aHp
+/GcuU2xE+krlsqI6kGsh3FVQ9XRJPDKC4mKDg+1S0mSE06PKhFsj6mN/Bp6Yq1V
byPfWjwAxvqSgAerVeHFBT4fKxk/qMXR9y9afn1acsaY2V5thGttCM0+1zcnGYH6
ERdQ8HYSvK/Nwy+PNt/eHIq1U7T63TExgExpnDp5LV074d5atcmNzT2ZV/LZodOD
YkKdJdx52iQBT/hmRNxH1UySVrduqG5Da+aNv21ipdcSmWCCuUteufcf7U+HqA6G
3HGe2cXzQq2qn3Db2P+3zXupSFsOcrrG+ghPTdZHkawhCmSuRYufkHciVrHpWQE7
kI+ahXKQFPRmDx8h+vBvqu31P3tSRtSV3K3fKYjVLednH8ZNqkPWY9i+vk5/bsM4
vVe6UXxxQqVBTD8Zb8Y8V5FEn0OrCi0YUwYrt1DTBEVx5QxQ/ROQhuLgYvgPoXSC
wajcaT5/qdDz0xEnCIg9
=uThJ
-----END PGP SIGNATURE-----

--E/DnYTRukya0zdZ1--
