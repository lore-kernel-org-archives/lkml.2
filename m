Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975Ab2JDMzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 08:55:36 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54551 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756760Ab2JDMzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 08:55:32 -0400
Message-ID: <506D8720.8040004@ti.com>
Date: Thu, 4 Oct 2012 18:24:56 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Matt Porter <mporter@ti.com>
CC: Philipp Zabel <pza@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Ben Gardiner <bengardiner@nanometrics.ca>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 0/6] uio_pruss cleanup and platform support
References: <1349276133-26408-1-git-send-email-mporter@ti.com> <20121004091145.GA3317@pengutronix.de> <20121004124253.GC11149@beef>
In-Reply-To: <20121004124253.GC11149@beef>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/4/2012 6:12 PM, Matt Porter wrote:
> On Thu, Oct 04, 2012 at 11:11:45AM +0200, Philipp Zabel wrote:
>> Hi Matt,
>>
>> On 10/3/12, Matt Porter <mporter@ti.com> wrote:
>>> This series enables uio_pruss on DA850 and removes use of the
>>> private SRAM API by the driver. The driver previously was not
>>> enabled by any platform and the private SRAM API was accessing
>>> an invalid SRAM bank.
>>
>> have you seen my SRAM patch series at https://lkml.org/lkml/2012/9/7/281
>> "Add device tree support for on-chip SRAM" ?
> 
> Yes.
> 
>> I think the generic SRAM/genalloc driver (https://lkml.org/lkml/2012/9/7/282)
>> could be useful to map the L3RAM on Davinci.
>> With the gen_pool lookup patch (https://lkml.org/lkml/2012/9/7/284) the
>> uio_pruss driver could then use the gen_pool_find_by_phys() (or
>> of_get_named_gen_pool() for initialization from device tree) to
>> retrieve the struct gen_pool*.
>>
>> This way you could avoid handing it over via platform data and you could
>> get rid of arch/arm/mach-davinci/{sram.c,include/mach/sram.h} completely.
> 
> I did miss the gen_pool_find_by_phys() call in that series. That does
> look useful. I actually mentioned your series in an earlier posting
> since I like it, but since the initialization of the driver was inherently
> tied to DT it's not usable for DaVinci that's just starting to convert
> to DT and needs !DT support as well.
> 
> I do see it moving to your driver exclusively, but I wanted to make this
> series focused on only getting rid of the private SRAM API using the
> existing pdata framework that's already there. I think once
> gen_pool_find_by_phys() goes upstream we can switch to that and get the
> address from a resource in the !DT case. I guess we should see if Sekhar
> would like to see this happen in two steps or just have us depend on
> the gen_pool_find_by_phys() patch now.

I prefer going with this series now and switching to the SRAM driver
once it is available mainline.

Thanks,
Sekhar
