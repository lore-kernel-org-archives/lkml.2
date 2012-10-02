Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab2JBLOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 07:14:43 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51748 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848Ab2JBLOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 07:14:41 -0400
Message-ID: <506ACC77.9090604@ti.com>
Date: Tue, 2 Oct 2012 16:43:59 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Ben Gardiner <bengardiner@nanometrics.ca>
CC: Matt Porter <mporter@ti.com>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Paul Walmsley <paul@pwsan.com>, Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Subhasish Ghosh <subhasish@mistralsolutions.com>
Subject: Re: [PATCH v2 4/7] ARM: davinci: Add support for an L3RAM gen_pool
References: <1348861072-14507-1-git-send-email-mporter@ti.com> <1348861072-14507-5-git-send-email-mporter@ti.com> <506986B2.1030000@ti.com> <20121001123242.GJ5641@beef> <CAPcSpELdAK6=O8HG9FJXG_t88eymZO1f3wxzFqmR-faUn4jx4g@mail.gmail.com>
In-Reply-To: <CAPcSpELdAK6=O8HG9FJXG_t88eymZO1f3wxzFqmR-faUn4jx4g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/1/2012 7:20 PM, Ben Gardiner wrote:
> On Mon, Oct 1, 2012 at 8:32 AM, Matt Porter <mporter@ti.com> wrote:
>> On Mon, Oct 01, 2012 at 05:34:02PM +0530, Sekhar Nori wrote:
>>> Hi Matt,
>>>
>>> On 9/29/2012 1:07 AM, Matt Porter wrote:
>>>> L3RAM (shared SRAM) is needed for use by several drivers.
>>>> This creates a genalloc pool and a hook for the platform code
>>>> to provide the struct gen_pool * in platform data.
>>>>
>>>> Signed-off-by: Matt Porter <mporter@ti.com>
>>>
>>> I am not sure if any of the DaVinci devices have a need to allocate from
>>> *both* ARM RAM and shared RAM. Shared RAM is not present on all DaVinci
>>> devices AFAIR, and on DA850, there is just 8KB ARM RAM so I am not sure
>>> if there is much point in trying to allocate from there.
>>>
>>> Can you instead see if Ben's earlier patch[1] to use shared RAM for SRAM
>>> allocation on DA850 makes sense for your case? If yes, can you repost
>>> with Ben's patch included in your series instead of this patch? I would
>>> prefer that over creating a new pool for shared RAM.
>>
>> Hrm, I did look at Ben's earlier patch. The reason I added a separate
>> pool mostly was so I didn't have to touch the PM code at all. That can
>> continue using the private SRAM API with the ARM RAM as it is now. The
>> idea here was to allow that to be separate since no other bus masters
>> can access the ARM RAM anyway and do something that didn't require
>> regression testing PM. Also, I figured there's really no reason to use
>> even a tiny bit of the shared SRAM on PM if we have that ARM RAM there
>> and working fine for that use case.
>> [...]
> 
> I agree with Matt. Preserving the use of the ARM RAM (8K on L138 -- as
> you said, Sekhar) in any fashion is preferable to moving suspend
> support into shared RAM. There is more of it (128K on L138) but also
> more pressure on allocations there since there are more clients.

There is where I would like to see more information on who the potential
clients are. Even if DSP takes away 64K of the shared RAM on OMAP-L138,
there should be more than enough for PM, Audio and PRU. I haven't
checked the PM code size lately but it should be fairly small and I can
check the actual number if that helps. So, adding a new pool just to
save on those bytes doesn't sound like helping a lot.

> I appreciate that you are trying to preserve prior efforts in
> attempted merging of SRAM support -- thank you for that; however, that
> patch [1] was just an import of Subashish Ghosh's patch [2]  -- I
> chose _that_ implementation option then mainly because I imagined it
> would be the least risky to get accepted upstream and not because of
> any particular technical merits.

Its not a question of prior effort since Matt has already put in the
effort too. I am yet unconvinced that we need to add support to manage
two blocks of SoC internal RAM on DA850 in the kernel today. That's all.

Thanks,
Sekhar
