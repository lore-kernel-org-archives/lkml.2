Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab1KAQ4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 12:56:21 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8344 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389Ab1KAQ4U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 12:56:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 01 Nov 2011 09:56:01 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Taylor Hutt <thutt@chromium.org>
CC: "miletus@chromium.org" <miletus@chromium.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Tue, 1 Nov 2011 09:55:59 -0700
Subject: RE: [PATCH] ASoc : Tegra : Add audio map for Asymptote
Thread-Topic: [PATCH] ASoc : Tegra : Add audio map for Asymptote
Thread-Index: AcyYs/DXEU8iyK3HTKaRuWAFUc7W8QAApmyA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173EDABA51@HQMAIL01.nvidia.com>
References: <1320165173-3951-1-git-send-email-thutt@chromium.org>
In-Reply-To: <1320165173-3951-1-git-send-email-thutt@chromium.org>
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

Taylor Hutt wrote at Tuesday, November 01, 2011 10:33 AM:
> Details
> 
>   Add pin connections and audio map for the Asymptote board.
> 
> Testing
> 
>   Visual inspection with Chromium OS 2.6.38 code.
>   Built kernel
>   Built chromium os image
>   Booted image on asymptote
>   Booted image on kaen

Presumably all that testing was within the chromeos-3.0 kernel, not
mainline; asymptote isn't supported in mainline.

This patch can't be applied for a few reasons:

a) Asymptote isn't in mainline's arch/arm/tools/mach-types. This means
that function machine_is_asymptote() doesn't exists, and this code can't
compile.

b) Even if the machine were in mach-types, there's no board file for
asymptote, so Russell King's automated mach-types cleanup script would
flag asymptote for removal and eventually it'd go away. This is the same
reason we recently removed Ventana support from tegra_wm8903.c. I'm not
sure how this will work once we have device-tree-only boards; I guess
we need to remove all the machine_is_foo() checks from the code and
parameterize everything from DT instead.

-- 
nvpublic

