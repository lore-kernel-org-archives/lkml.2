Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab2CEKZ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 05:25:59 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:57295 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756518Ab2CEKZ5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 05:25:57 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of balajitk@ti.com designates 10.112.87.234 as permitted sender) smtp.mail=balajitk@ti.com
MIME-Version: 1.0
In-Reply-To: <4F548457.5050205@ti.com>
References: <20120301185044.29210.44521.stgit@kaulin.local>
	<20120301185535.29210.71546.stgit@kaulin.local>
	<4F50643B.9050500@ti.com>
	<20120302172251.GJ18901@atomide.com>
	<4F548457.5050205@ti.com>
Date: Mon, 5 Mar 2012 15:55:56 +0530
Message-ID: <CANrkHUZysOnHKKUuLm0Vbo1KsNp0yUd=udjGvQ43=gTTXbWeCw@mail.gmail.com>
Subject: Re: [PATCH 4/4] mmc: omap_hsmmc: Simplify init for twl6030 MMC card detect
From: "T Krishnamoorthy, Balaji" <balajitk@ti.com>
To: Rajendra Nayak <rnayak@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        linux-arm-kernel@lists.infradead.org, Venkatraman S <svenkatr@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 5, 2012 at 2:46 PM, Rajendra Nayak <rnayak@ti.com> wrote:
> On Friday 02 March 2012 10:52 PM, Tony Lindgren wrote:
>>
>> BTW, with -rc5, looks like re-inserting omap_hsmmc on omap4 fails
>> to detect any cards, and then fails to unload. This works on omap3
>> just fine. Any ideas why that would be?
>
>
> Yeah, looks like thats broken. I am not sure whats going wrong though.
> I just enabled CONFIG_MMC_DEBUG and saw these logs below.
>
> Venkat/Balaji, care to look at this one?
>

Let me check this

> # insmod omap_hsmmc.ko
> [   43.358398] omap_hsmmc omap_hsmmc.0: context was not lost
> [   43.364105] omap_hsmmc omap_hsmmc.0: enabled
> [   44.434661] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0
> timing 0
> [   44.442352] omap_hsmmc omap_hsmmc.0: Set clock to 0Hz
> [   44.474365] omap_hsmmc omap_hsmmc.0: disabled
> [   44.482208] omap_hsmmc omap_hsmmc.4: context was not lost
> [   44.482208] omap_hsmmc omap_hsmmc.4: enabled
> [   44.546600] omap_hsmmc omap_hsmmc.0: context was not lost
> [   44.552276] omap_hsmmc omap_hsmmc.0: enabled
> [   44.552276] mmc0: mmc_rescan_try_freq: trying to init card at 400000 Hz
> [   44.563720] mmc0: clock 0Hz busmode 2 powermode 1 cs 0 Vdd 18 width 0
> timing 0
> [   44.572174] omap_hsmmc omap_hsmmc.0: Set clock to 0Hz
> [   44.613800] mmc0: clock 400000Hz busmode 2 powermode 2 cs 0 Vdd 18 width
> 0 timing 0
> [   44.621887] omap_hsmmc omap_hsmmc.0: Set clock to 400000Hz
> [   44.735290] mmc0: starting CMD52 arg 00000c00 flags 00000195
> [   44.741271] omap_hsmmc omap_hsmmc.0: mmc0: CMD52, argument 0x00000c00
> [   45.560241] mmc1: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0
> timing 0
> [   45.567871] omap_hsmmc omap_hsmmc.4: Set clock to 0Hz
> [   45.591491] omap_hsmmc omap_hsmmc.4: disabled
> #
> #
> # rmmod omap_hsmmc
> [  607.302307] omap_hsmmc omap_hsmmc.4: context was not lost
> [  607.308044] omap_hsmmc omap_hsmmc.4: enabled
> [  607.312591] omap_hsmmc omap_hsmmc.4: disabled
> [  607.317199] omap_hsmmc omap_hsmmc.4: context was not lost
> [  607.322875] omap_hsmmc omap_hsmmc.4: enabled
>
