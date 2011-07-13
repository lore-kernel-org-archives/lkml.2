Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360Ab1GMTvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 15:51:37 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:44963 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab1GMTvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 15:51:36 -0400
Message-ID: <4E1DF736.9020908@gentoo.org>
Date: Wed, 13 Jul 2011 22:51:18 +0300
From: Stratos Psomadakis <psomas@gentoo.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110626 Icedove/3.1.11
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        David Woodhouse <David.Woodhouse@intel.com>, kernel@gentoo.org
Subject: Re: -stable commit 87cc4d1e (bisected) causes system freeze
References: <CAAdZ7YhU=ETCYPhUq-3tB6tgRZ5ZA1fRKuyXT5aZMxU0-0gdFQ@mail.gmail.com> <4E1DEA24.3010109@gentoo.org>
In-Reply-To: <4E1DEA24.3010109@gentoo.org>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF02DCA4EFDA0BF4D1EEE1622"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF02DCA4EFDA0BF4D1EEE1622
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 13/07/2011 09:55 =CE=BC=CE=BC, Stratos Psomadakis wrote:
> On 13/07/2011 05:28 =CE=BC=CE=BC, Marcus Becker wrote:
>> Hi,
>>
>> With the upgrade to 2.6.39.2, I cannot copy more than ~1GB of data
>> over the network before my input devices lock up.
>> Example:
>> use scp on tty1 to copy a folder or file larger than 3GB over my
>> gigabit network and after ~1min the keyboard stops responding.
>> use cp on tty1 with an nfs-3 share mounted over the same network and
>> try to copy the same file, same happens
>>
>> I can hit ctrl+c for about 20-30 sec and eventually get an interrupt
>> that stops the copying, then the input devices slowly gain control
>> again. If I do the same on X, there is no chance to get in between and=

>> I have to use SysRq to reboot.
>>
>> In our bug report at https://bugs.gentoo.org/show_bug.cgi?id=3D373109
>> We did a bisect between 2.6.39.1 and 2.6.39.2 and found the following
>> patch is causing this problem:
>>
>> commit 87cc4d1e3e05af38c7c51323a3d86fe2572ab033
>> Author: Chris Wright <chrisw@sous-sol.org>
>> Date:   Sat May 28 13:15:04 2011 -0500
>>
>>     intel-iommu: Dont cache iova above 32bit
>>
>> I will also attach dmesg, current kernel config, and my bisect log (I
>> put a uname -a into the log after each bisect) plus git bisect log
>>
>> Please let me know if you need more information.
>>
>> Thanks,
>>
>> Marcus
> CC'ed the people who signed-off the patch.
>
Bug #39312 [1] at b.k.o

[1] https://bugzilla.kernel.org/show_bug.cgi?id=3D39312

--=20
Stratos Psomadakis
<psomas@gentoo.org>



--------------enigF02DCA4EFDA0BF4D1EEE1622
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk4d9z8ACgkQid1lVeNDMmDE+ACgp0ZVwHVLetF7KLqBD4L1VdHv
vpgAoLlTSeSuUXwog3vmy78k3pvLzPp0
=E0DT
-----END PGP SIGNATURE-----

--------------enigF02DCA4EFDA0BF4D1EEE1622--
