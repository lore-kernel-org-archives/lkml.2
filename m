Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab2ENKyi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 06:54:38 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:47919 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab2ENKye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 06:54:34 -0400
Message-ID: <4FB0E466.9050905@gmail.com>
Date: Mon, 14 May 2012 12:54:30 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Marco Stornelli <marco.stornelli@gmail.com>
CC: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH v2] Fix AFFS race condition.
References: <4FAFBAC1.20603@gmail.com> <20120514094543.GC5353@quack.suse.cz> <CANGUGtA=XfraVL28YqAM0t3oMjfud0Fn1VtJNxwt8=reG10nGA@mail.gmail.com>
In-Reply-To: <CANGUGtA=XfraVL28YqAM0t3oMjfud0Fn1VtJNxwt8=reG10nGA@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigE87006F5ADAC916515A9E7D2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE87006F5ADAC916515A9E7D2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 14.05.2012 12:40, Marco Stornelli wrote:

> 2012/5/14 Jan Kara <jack@suse.cz>:
>> On Sun 13-05-12 15:44:33, Vladimir '=CF=86-coder/phcoder' Serbinenko w=
rote:
>>> AFFS code preallocates several blocks as an optimisation. Unfortunate=
ly
>>> it's not protected by lock so the same blocks may end up allocated tw=
ice.
>>> Here is a fix.
>>>
>>> Signed-off-by: Vladimir Serbinenko <phcoder@gmail.com>
>>  The patch looks good to me now. Thanks! You can add:
>> Reviewed-by: Jan Kara <jack@suse.cz>
>>
>>  Al, will you merge this patch through your tree? AFFS does not seem t=
o
>> have a maintainer so you are a default fallback...
>>
>>                                                                Honza
>>
>=20
> I don't know the AFFS code, so only a question. Instead to use a spin
> lock, I think we can use a simple mutex. Or is the spin lock
> mandatory?

My first version used mutex. But then Jan suggested that since the
critical section is very short and doesn't contain any instructions
which might sleep, it's better for performance to use a spin lock.

--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko


--------------enigE87006F5ADAC916515A9E7D2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk+w5GcACgkQNak7dOguQglSZQD+Jk1bRg87Ly5/Wyt1h1B1HDgF
8R/YmNGqdO9UoSBXD8IBAKLhYRA7GLA1FN3EzpXS6HKxyD3PmDwtoBauYsyr2WTQ
=nsj4
-----END PGP SIGNATURE-----

--------------enigE87006F5ADAC916515A9E7D2--
