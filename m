Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab2LQVaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 16:30:08 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:46360 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab2LQVaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 16:30:04 -0500
Message-ID: <50CF8ED8.2030602@wwwdotorg.org>
Date: Mon, 17 Dec 2012 14:30:00 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Laxman Dewangan <ldewangan@nvidia.com>, alan@linux.intel.com,
        gregkh@linuxfoundation.org, jslaby@suse.cz, grant.likely@secretlab.ca,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH] serial: tegra: add serial driver
References: <1355746249-15347-1-git-send-email-ldewangan@nvidia.com> <50CF393F.4040009@gmail.com>
In-Reply-To: <50CF393F.4040009@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2012 08:24 AM, Rob Herring wrote:
> On 12/17/2012 06:10 AM, Laxman Dewangan wrote:
>> Nvidia's Tegra has multiple uart controller which supports:
>> - APB dma based controller fifo read/write.
>> - End Of Data interrupt in incoming data to know whether end
>>   of frame achieve or not.
>> - Hw controlled RTS and CTS flow control to reduce SW overhead.
>>
>> Add serial driver to use all above feature.
>>
>> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
>> ---
>>  .../bindings/serial/nvidia,serial-tegra.txt        |   26 +
> 
> Can we have a name without a comma. If serial-tegra is specific enough
> for the kernel, then it is for the binding doc too.

I would vastly prefer that the binding doc filenames use the compatible
value exactly. All (or as many as possible) of the other Tegra bindings
do this, and I think it's good style.

>> diff --git a/Documentation/devicetree/bindings/serial/nvidia,serial-tegra.txt b/Documentation/devicetree/bindings/serial/nvidia,serial-tegra.txt

>> +- nvidia,dma-request-selector : The Tegra DMA controller's phandle and
>> +  request selector for this UART controller.
> 
> This should use the generic DMA binding although I'm not sure if that
> made it into 3.8.

It didn't as far as I can tell, even though I think someone said it
should... Will it make 3.9? As a general rule, I'd like to move forward
on drivers and then refactor this aspect once the generic API/binding is
finalized and implemented.

(I couldn't find any more comments of yours below, but since the whole
patch was quoted, it was difficult to tell)
