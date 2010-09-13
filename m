Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab0IMQKf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 12:10:35 -0400
Received: from mail.ipom.com ([74.207.225.167]:37360 "EHLO mail.ipom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283Ab0IMQKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 12:10:34 -0400
X-Greylist: delayed 468 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Sep 2010 12:10:34 EDT
Message-ID: <4C8E4B14.7090904@ipom.com>
Date: Mon, 13 Sep 2010 18:02:28 +0200
From: Phil Dibowitz <phil@ipom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Alan Stern <stern@rowland.harvard.edu>, Jiri Slaby <jslaby@suse.cz>,
        stable@kernel.org, USB list <linux-usb@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [34-stable regression] USB delay init quirk causes device events
 loss
References: <4C8E3C40.50808@suse.cz> <Pine.LNX.4.44L0.1009131118180.1315-100000@iolanthe.rowland.org> <20100913155608.GA27853@suse.de>
In-Reply-To: <20100913155608.GA27853@suse.de>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1DBAB5ABA11EA6A8687144C2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1DBAB5ABA11EA6A8687144C2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 09/13/2010 05:56 PM, Greg KH wrote:
> On Mon, Sep 13, 2010 at 11:37:49AM -0400, Alan Stern wrote:
>> On Mon, 13 Sep 2010, Jiri Slaby wrote:
>>
>>> On 09/13/2010 04:48 PM, Alan Stern wrote:
>>>> On Mon, 13 Sep 2010, Jiri Slaby wrote:
>>>>> In other words, what I could do is to add some printks into
>>>>> hub_port_connect_change if that's called at all. If you need some
>>>>> thorough debugging printks, please send me a patch to test instead.=

>>>>
>>>> Hmm.  I'd prefer to explain how it's all supposed to work and let yo=
u
>>>> figure out where best to look.  Or try to debug it myself.  Does thi=
s
>>>> happen with other sorts of USB devices as well, or just wacom?
>>>
>>> With some sort of devices (I cannot reproduce myself). It's unrelated=
 to
>>> wacom -- people with wacom were unable to even start X with this kern=
el.
>>> If you look at the bugreport, there are several examples:
>>> ID 046d:c517 Logitech, Inc. LX710 Cordless Desktop Laser defunct
>>> Microsoft USB keyboard defunct x Logitech mice OK
>>> 046a:0021 Cherry GmbH keyboard defunct
>>> logitech wireless laptop mouse defunct
>>> A$Tech wireless laptop mouse defunct
>>> TypeMatrix USB 2030 (ID : 1e54:2030) defunct
>>
>> Okay, I see the problem.  By moving usb_detect_quirks earlier, we end =

>> up calling usb_disable_autosuspend too soon -- before the=20
>> pm_runtime_enable call in usb_new_device.  In 2.6.35 this doesn't=20
>> matter because the implementation of usb_autosuspend_device has=20
>> changed.
>>
>> So yes, in the end it looks like the best course is to revert this
>> patch from 2.6.34.stable.  This is unfortunate but I don't see any way=

>> around it without making changes that aren't present in the current
>> kernel. For example, the pm_runtime_set_active and pm_runtime_enable
>> calls could also be moved from usb_new_device into
>> hub_port_connect_change.
>=20
> Ok, I'll go revert that from the .34-stable tree and do a new release,
> as it's not nice to have a broken tree out there.

Sorry to chime in late on the conversation on my patch.

Thanks for figuring this out Alan. I think this is reasonable. However, I=

think this also went into .32-stable and should probably be reverted ther=
e
as well.

I'll advise my users to make sure they have at least .35.

--=20
Phil Dibowitz                             phil@ipom.com
Open Source software and tech docs        Insanity Palace of Metallica
http://www.phildev.net/                   http://www.ipom.com/

"Be who you are and say what you feel, because those who mind don't matte=
r
 and those who matter don't mind."
 - Dr. Seuss



--------------enig1DBAB5ABA11EA6A8687144C2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkyOSxQACgkQN5XoxaHnMrv3vgCdGRUfx6WFAkDKtRvTeqZWWVSI
hKEAoJItsQRTERPVfZwHPPYHP4lyJcso
=pFLs
-----END PGP SIGNATURE-----

--------------enig1DBAB5ABA11EA6A8687144C2--
