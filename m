Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab0IOS1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 14:27:25 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:45771 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937Ab0IOS1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 14:27:23 -0400
Message-ID: <4C911002.8060807@web.de>
Date: Wed, 15 Sep 2010 20:27:14 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: Zachary Amsden <zamsden@redhat.com>, kvm@vger.kernel.org,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM timekeeping 10/35] Fix deep C-state TSC desynchronization
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com> <1282291669-25709-11-git-send-email-zamsden@redhat.com> <4C8F3C03.50306@siemens.com> <4C904685.9090402@redhat.com> <4C907F3D.6070709@web.de> <20100915123215.GC3688@mothafucka.localdomain>
In-Reply-To: <20100915123215.GC3688@mothafucka.localdomain>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEE01C0A1315678CF4B7531C2"
X-Provags-ID: V01U2FsdGVkX1+iSacU4mosy+BuNDw5kPgvczCAl7/wafuovP3o
	locow4qrbMsMPGy53PinZte9VznH7BD6DR+f6PD2a+oay9E6cg
	yN5aHjOrM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEE01C0A1315678CF4B7531C2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 15.09.2010 14:32, Glauber Costa wrote:
> On Wed, Sep 15, 2010 at 10:09:33AM +0200, Jan Kiszka wrote:
>>> In any case, I'll proceed with the forcing of unstable TSC and HPET
>>> clocksource and see what happens.
>>
>> I tried that before, but it did not trigger the issue that kvm-clock
>> guests no longer boot properly. This only happens if the TSC is marked=

>> unstable.
>=20
> even artificially marked unstable ?
>=20

Yes. As soon as I hack tsc_unstable to 1, things go wrong. When I hack
it back to 0, guest that wants kvm-clock boots again and seem to run fine=
=2E

This is issue #2, I guess. Issue #2 remains that the TSC is marked
unstable. I have the feeling that this is bogus, maybe due to lacking
suspend/resume awareness? The tsc clocksource does

	clocksource_tsc.cycle_last =3D 0;

on resume...

Jan


--------------enigEE01C0A1315678CF4B7531C2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAkyREAgACgkQitSsb3rl5xSxKQCfTEU0IbTC+pM5yLGTkhxWq2zI
P1IAoN7BiZ7wvYgdon0Jq5PaxGKq7uRl
=okRr
-----END PGP SIGNATURE-----

--------------enigEE01C0A1315678CF4B7531C2--
