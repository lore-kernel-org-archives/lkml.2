Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab2IQNRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 09:17:08 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:45735
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754871Ab2IQNRG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 09:17:06 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: VPS-6(zz9371I542M1432Id6f1izz1202h1d1ah1d2ahzz8275dhz2dh668h839h944hd25hf0ah107ah1220h1288h12a5h12a9h12bdh1155h)
X-WSS-ID: 0MAHWW5-02-4VJ-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Andres Freund <andres@anarazel.de>, LKML <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: RE: radeon: Regression between v3.6-rc4 and v3.6-rc6: unable to
 allocate a PPLL
Thread-Topic: radeon: Regression between v3.6-rc4 and v3.6-rc6: unable to
 allocate a PPLL
Thread-Index: AQHNlMf4cJj+N2GqCk+osvT7J0ZY3JeOgYkg
Date: Mon, 17 Sep 2012 13:16:56 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D02C433367@sausexdag03.amd.com>
References: <201209171329.15699.andres@anarazel.de>
In-Reply-To: <201209171329.15699.andres@anarazel.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.224.12.207]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Andres Freund [mailto:andres@anarazel.de]
> Sent: Monday, September 17, 2012 7:29 AM
> To: LKML; Deucher, Alexander; David Airlie; dri-devel@lists.freedesktop.org
> Subject: radeon: Regression between v3.6-rc4 and v3.6-rc6: unable to
> allocate a PPLL
> 
> Hi,
> 
> While debugging another issue I upgraded from v3.6-rc4 to latest git (which
> exactly is v3.6-rc6). After X started up one of my three monitors blacked out.
> A look into the kernel log revealed:
> [drm:radeon_atom_pick_pll] *ERROR* unable to allocate a PPLL


What 3 monitors are you using (DVI, HDMI, DP, VGA)? Note that there are only 2 PLLs for non-DP monitors, so if you are trying to use more than 2 non-DP monitors, it's not supported right now and if it worked before, it was random luck.  If you want to use 3+ monitors, only 2 can be non-DP, the rest need to be DP.  If you use a DP to DVI/HDMI adapter, it must be active (looks like DP to the GPU), passive adapters just pass through native DVI/HDMI.  That said, I've got a set of patches for 3.7 to allow PLL sharing properly for non-DP displays, but it's too invasive for -fixes.

Alex


