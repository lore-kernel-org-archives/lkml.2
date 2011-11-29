Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab1K2WTd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 17:19:33 -0500
Received: from os.inf.tu-dresden.de ([141.76.48.99]:40085 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab1K2WTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 17:19:31 -0500
Date: Tue, 29 Nov 2011 23:19:09 +0100
From: Udo Steinberg <udo@hypervisor.org>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: MCE/Package power limit notification
Message-ID: <20111129231909.2c9ed5da@x220.fritz.box>
In-Reply-To: <20111129214342.GB5412@linux-os.sc.intel.com>
References: <20111123160950.67860131@x220>
	<987664A83D2D224EAE907B061CE93D53027D89B577@orsmsx505.amr.corp.intel.com>
	<493994B35A117E4F832F97C4719C4C04022D835792@orsmsx505.amr.corp.intel.com>
	<20111129222424.498469fe@x220.fritz.box>
	<20111129214342.GB5412@linux-os.sc.intel.com>
X-Mailer: X-Mailer 5.0 Gold
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/1mUo2b6bJgLX1t11iIba57M"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/1mUo2b6bJgLX1t11iIba57M
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Fenghua,

On Tue, 29 Nov 2011 13:43:43 -0800 Fenghua Yu (FY) wrote:

FY> Could you please check counters in /sys/devices/system/cpu/cpu#/thermal=
_throttle
FY> and see which counters report the thermal events?

cpu0/thermal_throttle/core_power_limit_count : 0
cpu0/thermal_throttle/core_throttle_count : 102536
cpu0/thermal_throttle/package_power_limit_count : 384
cpu0/thermal_throttle/package_throttle_count : 183429
cpu1/thermal_throttle/core_power_limit_count : 0
cpu1/thermal_throttle/core_throttle_count : 102536
cpu1/thermal_throttle/package_power_limit_count : 384
cpu1/thermal_throttle/package_throttle_count : 183429
cpu2/thermal_throttle/core_power_limit_count : 0
cpu2/thermal_throttle/core_throttle_count : 104859
cpu2/thermal_throttle/package_power_limit_count : 384
cpu2/thermal_throttle/package_throttle_count : 183429
cpu3/thermal_throttle/core_power_limit_count : 0
cpu3/thermal_throttle/core_throttle_count : 104859
cpu3/thermal_throttle/package_power_limit_count : 384
cpu3/thermal_throttle/package_throttle_count : 183429

FY> The thought of the patch is to remove the errors in mcelog and report t=
he errors
FY> in respective counters. Therefore, the events are not reported as scary=
 hardware
FY> issues but are still captured in counters.

I'm still seeing the following messages:

CPU2: Package temperature above threshold, cpu clock throttled (total event=
s =3D 146147)
CPU3: Package temperature above threshold, cpu clock throttled (total event=
s =3D 146147)
CPU1: Package temperature above threshold, cpu clock throttled (total event=
s =3D 146147)
CPU0: Package temperature above threshold, cpu clock throttled (total event=
s =3D 146147)
CPU0: Package temperature/speed normal
CPU2: Package temperature/speed normal
CPU1: Package temperature/speed normal
CPU3: Package temperature/speed normal
CPU3: Core temperature above threshold, cpu clock throttled (total events =
=3D 81740)
CPU2: Core temperature above threshold, cpu clock throttled (total events =
=3D 81740)
CPU2: Core temperature/speed normal
CPU3: Core temperature/speed normal
[Hardware Error]: Machine check events logged

FY> I think BIOS/firmware sets up power limit or thermal throttle incorrect=
ly and
FY> triggers events incorrectly. You may try updated BIOS to see if the eve=
nts go
FY> away.

I'm running the latest BIOS on my Lenovo Thinkpad X220. Someone should talk
to Lenovo about getting this fixed. My machine reports:

DMI: LENOVO 4290W4H/4290W4H, BIOS 8DET54WW (1.24 ) 10/18/2011

Cheers,

	- Udo

--Sig_/1mUo2b6bJgLX1t11iIba57M
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7VWl0ACgkQnhRzXSM7nSm9QQCfS3hjMrWO0O4val9At9J89D1V
AfsAn30X7fgJf7oeos6MavDcX9PxltIp
=HO+P
-----END PGP SIGNATURE-----

--Sig_/1mUo2b6bJgLX1t11iIba57M--
