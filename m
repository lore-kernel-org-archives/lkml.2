Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab1KARFg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 13:05:36 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4156 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787Ab1KARFe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 13:05:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 01 Nov 2011 10:05:17 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Taylor Hutt <thutt@chromium.org>
CC: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Tue, 1 Nov 2011 10:05:15 -0700
Subject: RE: [PATCH] asoc: tegra: wm8903: Simplify pin disconnect
Thread-Topic: [PATCH] asoc: tegra: wm8903: Simplify pin disconnect
Thread-Index: AcyYswuOyWxErSmhTmaayyLpIZEQawABGtqg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173EDABA68@HQMAIL01.nvidia.com>
References: <1320164771-457-1-git-send-email-thutt@chromium.org>
In-Reply-To: <1320164771-457-1-git-send-email-thutt@chromium.org>
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

Taylor Hutt wrote at Tuesday, November 01, 2011 10:26 AM:
> (Note that this patch fails the kernel patch checker because
>  the 'M' macro produces an error that it's value should be enclosed
>  in parenthesis; this is not actually possible for this use & expansion.)
> 
> Detail
> 
>   This change is a simplification, both in implementation and for
>   reasoning about whcih pins are connected and disconnected.
> 
>   The impetus for the change was the addition of new boards, and the
>   difficulty in reasoning about the previous code to disconnect pins.
> 
>   Now, unless a connection is specified for the current board, the pin
>   will be disconnected.
> 
>   A follow-on change will add the 'asymptote' board.
> 
> Testing
> 
>   Visual inspection from original code.
>   Built kernel.

As I mentioned in the ChromeOS review, I don't like this approach.

The main issue is that all the connectivity information is already present
in the ${machine}_audio_maps[] arrays, and this change duplicates it all
in the data-structures inside tegra_wm8903_disconnect_pins().

Instead, I believe a function should be added to the ASoC core that reads
the machine's dapm routes, and does the same thing based on that. Mark
Brown pointed out that this should be an optional utility function that
machine drivers should call, since applying it automatically might cause
issues for some other machines.

The second issue here is that the new code calls machine_is_ventana()
and the equivalent for other machines, and some of those functions will go
away next time Russell updates mach-types and removes entries for boards
that aren't supported with an explicit board file.

-- 
nvpublic

