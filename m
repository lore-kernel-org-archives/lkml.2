Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab1KBGNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 02:13:18 -0400
Received: from portal.weinmann.de ([62.8.140.122]:9386 "EHLO
	portal.weinmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab1KBGNQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 02:13:16 -0400
X-Greylist: delayed 971 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Nov 2011 02:13:15 EDT
From: "Voss, Nikolaus" <N.Voss@weinmann.de>
To: "'H Hartley Sweeten'" <hartleys@visionengravers.com>,
        =?iso-8859-1?Q?=27H=E5vard_Skinnemoen=27?= <hskinnemoen@gmail.com>
CC: "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 2 Nov 2011 06:56:50 +0100
Subject: RE: [PATCH] i2c-gpio.c: correct logic of pdata->scl_is_open_drain
Thread-Topic: [PATCH] i2c-gpio.c: correct logic of pdata->scl_is_open_drain
Thread-Index: AcyYZE/mlvGDbQhsR7a2xIKWGvqqQgABwoQgABHIWCAAG9UGYA==
Message-ID: <EF2E73589CA71846A15D0B2CDF79505D087B34C115@wm021.weinmann.com>
References: <EF2E73589CA71846A15D0B2CDF79505D087B34BE51@wm021.weinmann.com>
	<CAF8ieYXPMgUzekth7PGxC3AgYNKac-HQ21D3vvB5J3SLOatmfQ@mail.gmail.com>
	<EF2E73589CA71846A15D0B2CDF79505D087B34BE8B@wm021.weinmann.com>
	<CAF8ieYWY2RwkgPERgagvw2bby8Y+UFgrYr3zPOb27e=bfOH-vg@mail.gmail.com>
 <EF2E73589CA71846A15D0B2CDF79505D087B34BEE2@wm021.weinmann.com>
 <ADE657CA350FB648AAC2C43247A983F001F39DF77673@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F001F39DF77673@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US, de-DE
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, de-DE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If the "is_open_drain" flags are not set, the I2C bus works correctly
> regardless of the existence of the pull-ups.

No, I2C can only work with anything pulling up SDA weakly, usually an
external pullup. This is independent of the "is_open_drain" property
which only describes how the driver internally accomplishes the high
impedance state.

SCL can be driven push-pull ("scl_is_output_only") but will not be
I2C-compliant any more (no clock stretching), and only clients not relying
on that feature will work.

Niko

