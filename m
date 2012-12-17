Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab2LQV7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 16:59:34 -0500
Received: from rs130.luxsci.com ([72.32.115.17]:54121 "EHLO rs130.luxsci.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768Ab2LQV7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 16:59:31 -0500
Message-ID: <50CF9580.4050300@firmworks.com>
Date: Mon, 17 Dec 2012 11:58:24 -1000
From: Mitch Bradley <wmb@firmworks.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Laxman Dewangan <ldewangan@nvidia.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, linux-doc@vger.kernel.org,
        gregkh@linuxfoundation.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-tegra@vger.kernel.org, jslaby@suse.cz, alan@linux.intel.com
Subject: Re: [PATCH] serial: tegra: add serial driver
References: <1355746249-15347-1-git-send-email-ldewangan@nvidia.com> <50CF9043.8030308@wwwdotorg.org>
In-Reply-To: <50CF9043.8030308@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Lux-Comment: Message qBHLwNan022427 sent by user #11875
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2012 11:36 AM, Stephen Warren wrote:
> On 12/17/2012 05:10 AM, Laxman Dewangan wrote:
>> Nvidia's Tegra has multiple uart controller which supports:
>> - APB dma based controller fifo read/write.
>> - End Of Data interrupt in incoming data to know whether end
>>   of frame achieve or not.
>> - Hw controlled RTS and CTS flow control to reduce SW overhead.
> 
>> diff --git a/Documentation/devicetree/bindings/serial/nvidia,serial-tegra.txt b/Documentation/devicetree/bindings/serial/nvidia,serial-tegra.txt
> 
>> +NVIDIA Tegra20/Tegra30 high speed (dma based) UART controller driver.
>> +
>> +Required properties:
>> +- compatible : should be "nvidia,tegra20-hsuart", "nvidia,tegra30-hsuart".
> 
> One question that isn't addressed here is:
> 
> Tegra has 5 UARTs. All of them can use the existing 8250.c by specifying
> compatible = "nvidia,tegra20-uart".

The way it is supposed to work is that the compatible property should
list "nvidia,tegra30-hsuart" first, followed by a fallback name that
refers to the generic 8250 compatibility.  Having the 8250.c driver bind
to the more-specific tegra30-hsuart name is wrong.

 However, the 8250.c driver doesn't
> support the DMA features of this driver. This driver is an alternate
> driver for the same HW that allows DMA to be used with it, etc.
> 
> Since DT is supposed to describe the HW, modifying the DT to change the
> compatible value in order to select a different driver in Linux doesn't
> seem correct, or is it? Is there any kind of precedent for how to select
> different drivers for the same HW at run-time? I'd wondered about using
> the sysfs bind/unbind "methods" from user-space as the driver selection
> mechanism...
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
> 
