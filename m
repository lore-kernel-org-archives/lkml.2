Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab2LQWEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 17:04:11 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:41518 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab2LQWEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 17:04:08 -0500
Message-ID: <50CF96D4.6010705@wwwdotorg.org>
Date: Mon, 17 Dec 2012 15:04:04 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mitch Bradley <wmb@firmworks.com>
CC: Laxman Dewangan <ldewangan@nvidia.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, linux-doc@vger.kernel.org,
        gregkh@linuxfoundation.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-tegra@vger.kernel.org, jslaby@suse.cz, alan@linux.intel.com
Subject: Re: [PATCH] serial: tegra: add serial driver
References: <1355746249-15347-1-git-send-email-ldewangan@nvidia.com> <50CF9043.8030308@wwwdotorg.org> <50CF9580.4050300@firmworks.com>
In-Reply-To: <50CF9580.4050300@firmworks.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2012 02:58 PM, Mitch Bradley wrote:
> On 12/17/2012 11:36 AM, Stephen Warren wrote:
>> On 12/17/2012 05:10 AM, Laxman Dewangan wrote:
>>> Nvidia's Tegra has multiple uart controller which supports:
>>> - APB dma based controller fifo read/write.
>>> - End Of Data interrupt in incoming data to know whether end
>>>   of frame achieve or not.
>>> - Hw controlled RTS and CTS flow control to reduce SW overhead.
>>
>>> diff --git a/Documentation/devicetree/bindings/serial/nvidia,serial-tegra.txt b/Documentation/devicetree/bindings/serial/nvidia,serial-tegra.txt
>>
>>> +NVIDIA Tegra20/Tegra30 high speed (dma based) UART controller driver.
>>> +
>>> +Required properties:
>>> +- compatible : should be "nvidia,tegra20-hsuart", "nvidia,tegra30-hsuart".
>>
>> One question that isn't addressed here is:
>>
>> Tegra has 5 UARTs. All of them can use the existing 8250.c by specifying
>> compatible = "nvidia,tegra20-uart".
> 
> The way it is supposed to work is that the compatible property should
> list "nvidia,tegra30-hsuart" first, followed by a fallback name that
> refers to the generic 8250 compatibility.  Having the 8250.c driver bind
> to the more-specific tegra30-hsuart name is wrong.

8250.c binds to nvidia,tegra20-uart, so that aspect is fine.

However, the real issue is that we probably want 4 of the 5 ports to use
the plain old 8250.c (so as not to use up too many DMA channels), but
just 1 of the ports to use the DMA-capable high-performance driver (e.g.
the one that a particular board has hooked up to a Bluetooth radio). The
only way to do that with DT that I know of would be to specify different
subsets of legal compatible values for each UART in the per-board .dts file.
