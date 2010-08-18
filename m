Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab0HRPxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 11:53:07 -0400
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:55695 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab0HRPxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 11:53:05 -0400
Date: Wed, 18 Aug 2010 17:51:28 +0200
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Ike Panhc <ike.pan@canonical.com>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Thomas Renninger <trenn@suse.de>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Corentin Chary <corentincj@iksaif.net>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        "Brown, Len" <len.brown@intel.com>, Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 0/8] [Resend] ideapad: using EC command to control
 rf/camera power
Message-ID: <20100818155128.GA24363@darkside.kls.lan>
Mail-Followup-To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>,
	David Woodhouse <dwmw2@infradead.org>,
	Ike Panhc <ike.pan@canonical.com>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	Thomas Renninger <trenn@suse.de>, Alan Cox <alan@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Corentin Chary <corentincj@iksaif.net>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	"Brown, Len" <len.brown@intel.com>,
	Matthew Garrett <mjg@redhat.com>
References: <1282120564-11324-1-git-send-email-ike.pan@canonical.com>
 <1282127719.2747.211.camel@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
In-Reply-To: <1282127719.2747.211.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 18, 2010 at 11:35:19AM +0100, David Woodhouse wrote:
> On Wed, 2010-08-18 at 09:36 +0100, Ike Panhc wrote:
> > This driver is tested and work fine on Lenovo ideapad B550 and ideapad =
S10-3.
> Works for me too (on S10-3); thanks.

It works for me too on S12 w/ VIA Nano - at least somehow... I have two
issues with it:

1st: the camera is not detected:

$ dmesg | grep -i cam
[    3.062601] usb 1-4: Product: Lenovo EasyCamera
[    7.828202] uvcvideo: Found UVC 1.00 device Lenovo EasyCamera (5986:0241)
[    7.842987] input: Lenovo EasyCamera as /devices/pci0000:00/0000:00:10.4=
/usb1/1-4/1-4:1.0/input/input6
$ lsusb | grep -i cam
Bus 001 Device 002: ID 5986:0241 Acer, Inc BisonCam, NB Pro
$ rfkill list
0: ideapad_wlan: Wireless LAN
        Soft blocked: no
        Hard blocked: no
1: ideapad_bluetooth: Bluetooth
        Soft blocked: no
        Hard blocked: no
2: ideapad_killsw: Wireless LAN
        Soft blocked: no
        Hard blocked: no
3: hci0: Bluetooth
        Soft blocked: no
        Hard blocked: no
4: phy0: Wireless LAN
        Soft blocked: no
        Hard blocked: no

Fn-Esc switches the Camera off and on, but there seems to be no soft
killswitch for it. I have no idea how to parse through acpidump to find
out whether there is some similar device listed or not.


2nd: both Bluetooth killswitches reproducibly disappear when I block
ideapad_bluetooth either via Gnome bluetooth-applet or via rfkill block
1 and subsequently reboot. After the reboot rfkill list shows:

0: ideapad_wlan: Wireless LAN
        Soft blocked: no
        Hard blocked: no
1: ideapad_killsw: Wireless LAN
        Soft blocked: no
        Hard blocked: no
2: phy0: Wireless LAN
        Soft blocked: no
        Hard blocked: no

Powering the machine off and on again restores both killswitches.
Interesting is: this does not happen when I boot into single-user mode,
rfkill block 1 there and reboot. In this case, both killswitches are
back.


regards
   Mario
--=20
File names are infinite in length where infinity is set to 255 characters.
                                -- Peter Collinson, "The Unix File System"

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTGwBgBS+e2HeSPbpAQII7Af/VpsRqJ4lZJnO/8SRGcIHB5cdIdKU5ODF
UP8gAS7YE96wSNXII/pjX9Fw3uyjJFixg/kYfH3QQYxEqlZLODwx31uWUdTTrTQv
sfm/G43tEASbGbccnR08kCtns87jC0DfUULlwwu5EeoE6/j4XX6dLTBlypXdSizZ
Arj3JUue7rOj/vkQxJcBW7e/69oOQqz/jAiq5Yu6CHnvI1OikFJJ+QgnBCPdEfYA
jX3zbHdLj681IQ3qsFK3FGuoXZ2bPagKQeHRv6zCm+Vdk+TtEAqcxiqJ9fIZlKsx
9UZJm0bNO9eTOxHyY6vYDSu9bVJMULYw/ux5w9rQyW5TbR0MAEAfBw==
=yq4T
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
