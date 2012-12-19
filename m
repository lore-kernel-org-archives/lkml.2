Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709Ab2LSNDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 08:03:21 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:61876 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab2LSNDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 08:03:14 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] serial: tegra: add serial driver
To: Mitch Bradley <wmb@firmworks.com>, Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, rob.herring@calxeda.com,
        linux-doc@vger.kernel.org, gregkh@linuxfoundation.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-tegra@vger.kernel.org,
        jslaby@suse.cz, alan@linux.intel.com
In-Reply-To: <50CF99EC.1050509@firmworks.com>
References: <1355746249-15347-1-git-send-email-ldewangan@nvidia.com> <50CF9043.8030308@wwwdotorg.org> <50CF9580.4050300@firmworks.com> <50CF96D4.6010705@wwwdotorg.org> <50CF99EC.1050509@firmworks.com>
Date: Wed, 19 Dec 2012 13:03:05 +0000
Message-Id: <20121219130307.B8FCB3E0AD7@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2012 12:17:16 -1000, Mitch Bradley <wmb@firmworks.com> wrote:
> On 12/17/2012 12:04 PM, Stephen Warren wrote:
> > On 12/17/2012 02:58 PM, Mitch Bradley wrote:
> >> On 12/17/2012 11:36 AM, Stephen Warren wrote:
> >>> On 12/17/2012 05:10 AM, Laxman Dewangan wrote:
> >>>> Nvidia's Tegra has multiple uart controller which supports:
> >>>> - APB dma based controller fifo read/write.
> >>>> - End Of Data interrupt in incoming data to know whether end
> >>>>   of frame achieve or not.
> >>>> - Hw controlled RTS and CTS flow control to reduce SW overhead.
> >>>
> >>>> diff --git a/Documentation/devicetree/bindings/serial/nvidia,serial-tegra.txt b/Documentation/devicetree/bindings/serial/nvidia,serial-tegra.txt
> >>>
> >>>> +NVIDIA Tegra20/Tegra30 high speed (dma based) UART controller driver.
> >>>> +
> >>>> +Required properties:
> >>>> +- compatible : should be "nvidia,tegra20-hsuart", "nvidia,tegra30-hsuart".
> >>>
> >>> One question that isn't addressed here is:
> >>>
> >>> Tegra has 5 UARTs. All of them can use the existing 8250.c by specifying
> >>> compatible = "nvidia,tegra20-uart".
> >>
> >> The way it is supposed to work is that the compatible property should
> >> list "nvidia,tegra30-hsuart" first, followed by a fallback name that
> >> refers to the generic 8250 compatibility.  Having the 8250.c driver bind
> >> to the more-specific tegra30-hsuart name is wrong.
> > 
> > 8250.c binds to nvidia,tegra20-uart, so that aspect is fine.
> > 
> > However, the real issue is that we probably want 4 of the 5 ports to use
> > the plain old 8250.c (so as not to use up too many DMA channels), but
> > just 1 of the ports to use the DMA-capable high-performance driver (e.g.
> > the one that a particular board has hooked up to a Bluetooth radio). The
> > only way to do that with DT that I know of would be to specify different
> > subsets of legal compatible values for each UART in the per-board .dts file.
> 
> 
> That's an okay way to do it.  The whole purpose of the compatible
> property is to support driver binding.  The mantra to "describe the
> hardware" is good, but shouldn't be taken to extremes.
> 
> It would be a good idea to comment the .dts file to explain why the
> compatible property differs between the otherwise-identical nodes.

+1

g.

