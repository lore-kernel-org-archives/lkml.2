Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120Ab1I3WMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 18:12:00 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13262 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab1I3WLw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 18:11:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 30 Sep 2011 15:11:23 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>
CC: Russell King <linux@arm.linux.org.uk>, Tony Lindgren <tony@atomide.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Simon Glass <sjg@chromium.org>, Allen Martin <AMartin@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 30 Sep 2011 15:11:21 -0700
Subject: RE: [PATCH] ARM: tegra: Make earlyprintk choose a UART at runtime.
Thread-Topic: [PATCH] ARM: tegra: Make earlyprintk choose a UART at runtime.
Thread-Index: Acx8eYjjdfxsSUvRTEeD0pLNQCCDhgDQ9BXA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173A2C6B44@HQMAIL01.nvidia.com>
References: <1317061425-1030-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1317061425-1030-1-git-send-email-dianders@chromium.org>
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

Doug Anderson wrote at Monday, September 26, 2011 12:24 PM:
> With this change we automatically detect which UART to use for
> earlyprintk (and for printing during decompression).  The
> detection involves coordination with the bootloader: it's expected
> that the bootloader will leave a 'D' (for [D]ebug) in the UART
> scratchpad register for whichever UART we should use for debugging.

This works fine on Tegra20; there, even if the UART clock is off and/or
the UART is in reset, you can still read the UART_SCR register (and get
a bogus value) without the system hanging.

However, I just tested on Tegra30, and the behavior has changed; if either
a UART is in reset /or/ the UART clock is stopped, then the system hangs
when UART_SCR is read.

As such, this change will cause Tegra30 to fail to boot. I'd rather it
was augmented to check the clock enable and module reset bits as well
as the scratch register value in all cases.

Yes, I know mainline doesn't support Tegra30 yet, but we're very close
to posting the first few patches to start enabling it, and I wouldn't
want to break it right before that!

-- 
nvpublic

