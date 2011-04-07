Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab1DGNVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 09:21:04 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:59793 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753840Ab1DGNVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 09:21:03 -0400
X-Greylist: delayed 340 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Apr 2011 09:21:03 EDT
Message-ID: <4D9DB8A8.2020408@gentoo.org>
Date: Thu, 07 Apr 2011 09:14:16 -0400
From: Joshua Kinard <kumba@gentoo.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linux MIPS List <linux-mips@linux-mips.org>
Subject: [PATCH 0/2]: rtc: rtc-ds1685: Add driver to support Dallas/Maxim
 DS1685/DS1687 & related chips
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


So I tried a little over a month ago to submit a driver to support the
Dallas/Maxim DS1685/DS1687-series of RTC chips.  After some very good feedback,
I pretty much decided to re-write most of the driver and hope this time, it
passes muster.

If it does, I'd like to get this queued for 2.6.40.  Please advise me of any
required steps for this.

Summary:
The DS1685/DS1687-series RTCs are direct descendants of the DS1285 through
DS1585 line of PC RTCs.  They support the usual bits for time, calendar, alarm,
and a small amount of user NVRAM through the use of four control registers (A
through D).  The DS1685/DS1687 extend this core support by adding two additional
registers (4A, 4B), century bits, month day alarm, wake-up/kickstart, extended
NV-SRAM, and a silicon-serial number.  These features are accessed via an
extended bank switched to by setting a bit in control register A.

In addition to the DS1685/DS1687, this driver supports the older DS1688/DS1691
and DS1689/DS1693 RTC chips (no functional difference between these two types),
as well as the newer DS17x85/DS17x87 chips that represent the current generation
of this particular family.  The key differences between all these models is
primarily in the total amount of available extended NV-SRAM and minor features,
such as burst-mode access to said NV-SRAM on the DS17x85/7 line.

The driver provides functionality for time, calendar, alarm, periodic frequency,
& power-off/management capabilities.  The power management is customizable via
platform_data on various platforms, in addition to configuring the register
step-size (if needed).  The driver currently relies on mmio to reach the
registers, which is a requirement on MIPS.  I've looked at a couple of other RTC
drivers that implement pio access, and have plans to add that in the future once
I hunt down some kind of gadget or dongle that maybe lets me test an RTC chip on
my PC directly.

I developed this driver primarily on an SGI O2 (IP32) system, which uses a
DS1687-5 RTC.  I have not been able to test the 17x87 line, though I am hoping
to get my hands on a DS17287-5 shortly to see if it's functional in my O2.  This
particular patch is just the core driver only.  Platform-specific bits (IP32)
will follow this patch to the Linux/MIPS list for review there.

If anyone notices anything outstanding, please let me know.  Hopefully I covered
all of my bases this time around...

Thanks!

- -- 
Joshua Kinard
Gentoo/MIPS
kumba@gentoo.org

"The past tempts us, the present confuses us, the future frightens us.  And our
lives slip away, moment by moment, lost in that vast, terrible in-between."

- --Emperor Turhan, Centauri Republic
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQIcBAEBAgAGBQJNnbinAAoJENsjoH7SXZXjbqcP/21OzOGt2x5oxDehSX/cNnTG
IV1pX4XXWxDBhKU9ssNdPUmgQOkDpEovuSUvcpDhpsMYWSKOP+CfxXm1IG80OzRx
aj3l1GVmtevh9Kcy97Z/zOg+JVQCFqNz3wK0MhJzD2l20jrBfVrd5tIQp+2y2wv0
MW1sxDXXdaL0XZISySf9VpyMH/d8KJ0mn6AlqtBfXEgjVayb7jn5o4WccqpTOf5G
OnhmiHVZR+5e/bOrC/dANams5FMKtroQzGdRqUiG1H4zM4i3mvULeNNDjjPcImN0
e74KqBzxWd4qXCoQ2CglTFgzg+gaScsOtV5KdLYn7Pu2k1z+gA9whKT/t/T+VjP7
yCdJktNGcto3KXHMLTSI3p7fghjlfHRT4x2r+EDpPoip3Yw8bpCzswTsh7zoO0XR
bViJ0vJY6NtiLocaxSN56QNr1rutvHLBkYcBh2+aAFCEjsghgbpjR8nY77MFdD16
rlSweArek8TN22YzEBOAdJ6P1NIA5GAFIs8ba4B4R944cVyhqlG/MHUCNwbLe0CO
oCntkpj30zAQTIX6rJPyfQhcaj/9D+fQjUaPpvQVC1bAXSrk6PSFx6810qvR2ZdJ
wYO9nrTeifUPjde/FYdRNr3Uq+MsSD63FBgc42eU+Sbum5mRj2OVTHpkxYQFuNDb
siylKDM6HSIgGa3FxpAo
=Lpkk
-----END PGP SIGNATURE-----
