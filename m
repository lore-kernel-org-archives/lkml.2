Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153Ab1JNQMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 12:12:32 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6554 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab1JNQMa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 12:12:30 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 14 Oct 2011 09:12:19 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "Colin Cross (ccross@android.com)" <ccross@android.com>,
        Erik Gilling <konkers@android.com>
Date: Fri, 14 Oct 2011 09:12:18 -0700
Subject: RE: [PATCH] arm/tegra: select AUTO_ZRELADDR by default
Thread-Topic: [PATCH] arm/tegra: select AUTO_ZRELADDR by default
Thread-Index: AcyKhh2Hsos8aI1KSxeQVVp2NZzzfgABTU0Q
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173BE1A283@HQMAIL01.nvidia.com>
References: <1317172068-14872-1-git-send-email-pdeschrijver@nvidia.com>
 <20111014071500.GP21648@n2100.arm.linux.org.uk>
 <74CDBE0F657A3D45AFBB94109FB122FF173BE1A260@HQMAIL01.nvidia.com>
 <201110141729.41515.arnd@arndb.de>
In-Reply-To: <201110141729.41515.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote at Friday, October 14, 2011 9:30 AM:
...
> You mention that tegra30 will require AUTO_ZRELADDR.

Well, just to be clear, here's the situation I think:

Tegra20's SDRAM starts at physical address 0.

Tegra30's SDRAM starts at physical address 2G.

To support that, we could either:

a) Introduce a new Kconfig variable for Tegra30, make T20/T30 mutually
exclusive, and update arch/arm/mach-tegra/Makefile.boot to set zreladdr
etc. based on the new Tegra30 config variable too. Then, there's no need
for AUTO_ZRELADDR anywhere.

b) Have no new config variable, build a unified T20/T30 kernel, leave
Makefile.boot untouched, and rely on using AUTO_ZRELADDR for Tegra30 to
account for the different SDRAM physical addresses.

> Does that mean that with tegra30 merged you would no longer be able
> to build any tegra kernel?

Sorry, I don't quite understand that question.

-- 
nvpublic

