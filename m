Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab2JBW7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 18:59:54 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:23250 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755240Ab2JBW7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 18:59:52 -0400
X-Forefront-Antispam-Report: CIP:160.33.194.230;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail03v.am.sony.com;RD:mail03.sonyusa.com;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zzbb2dI98dI9371I1432I111aIzz1202h1d1ah1d2ahzz8275bhz2fh2a8h668h839h93fhd25hf0ah107ah1288h12a5h12a9h12bdh137ah13b6h1441h1155h)
Message-ID: <506B70C7.6080001@am.sony.com>
Date: Tue, 2 Oct 2012 15:55:03 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Robert Nelson <robertcnelson@gmail.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Problem with mmc DMA on panda board in 3.6
References: <506B69B0.2010109@am.sony.com> <CAOCHtYjLFE0aXL_ReZSdQZFJDPRW3Cx3vk4WEo9DU4g8QiF=gg@mail.gmail.com>
In-Reply-To: <CAOCHtYjLFE0aXL_ReZSdQZFJDPRW3Cx3vk4WEo9DU4g8QiF=gg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2012 03:28 PM, Robert Nelson wrote:
> On Tue, Oct 2, 2012 at 5:24 PM, Tim Bird <tim.bird@am.sony.com> wrote:
>> This is an early report - I'm just checking if anyone else has seen this.
>>
>> With Linux version v3.6, my PandaBoard (OMAP-based) no longer boots.  The
>> system appears to fail to initialize the mmc controller.
>>
>> The kernel log message of interest appears to be this:
>> [    1.690002] omap_hsmmc omap_hsmmc.0: unable to obtain RX DMA engine channel 6
>>
>> I can supply full kernel log messages and my .config if needed.
>>
>> I bisected the code and arrived at the following commit:
>> -------
>> commit 26b88520b80695a6fa5fd95b5d97c03f4daf87e0
>> Author: Russell King <rmk+kernel@arm.linux.org.uk>
>> Date:   Fri Apr 13 12:27:37 2012 +0100
>>
>>     mmc: omap_hsmmc: remove private DMA API implementation
>>
>>     Remove the private DMA API implementation from omap_hsmmc, making it
>>     use entirely the DMA engine API.
>>
>>     Tested-by: Tony Lindgren <tony@atomide.com>
>>     Tested-by: Venkatraman S <svenkatr@ti.com>
>>     Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
>> -------
>> The board works up until this commit.
>> After this commit, the board hangs during boot after the message:
>> [    1.852508] Waiting for root device /dev/mmcblk0p3...
>> (and some other USB and network messages, which I presume
>> are unrelated.)
>>
>> My questions are these:
>> Has anyone else had problems with the PandaBoard (or other OMAP) on 3.6?
>> Are there any related CONFIG_ variables I could change to try alternatives?
>> What should I try next to debug this?
> 
> Check your config, to see if these are enabled:
> 
> CONFIG_DMADEVICES=y
> CONFIG_DMA_OMAP=y

They were not.  After enabling them, things work as expected.

Thanks very much!! :-)

I've been doing the following on a mainline kernel to generate the
.config for my panda board:

make omap2plus_defconfig
ttc set_config CONFIG_USB_EHCI_HCD=y CONFIG_MFD_OMAP_USB_HOST=y CONFIG_USB_EHCI_ROOT_HUB_TT=N CONFIG_USB_EHCI_TT_NEWSCHED=y CONFIG_USB_EHCI_HCD_OMAP=y CONFIG_USB_EHCI_MV=n
ttc set_config CONFIG_USB_NET_SMSC95XX=y CONFIG_USB_SISUSBVGA=n
make oldconfig

I've kind of lost track of the preferred method of doing board-specific configurations,
since the big defconfig purge of 2011.  I think I need to go back to the drawing board
on my automatic config-setting.

In any event, thanks again.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

