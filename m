Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab1J2JfU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 05:35:20 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35678 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab1J2JfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 05:35:19 -0400
Date: Sat, 29 Oct 2011 10:34:58 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, msb@chromium.org,
        linux-kernel@vger.kernel.org, sergiu@chromium.org,
        Bryan Freed <bfreed@chromium.org>, akpm@linux-foundation.org,
        seiji.aguchi@hds.com
Subject: Re: [PATCH] ramoops appears geared to not support ARM
Message-ID: <20111029093458.GX19187@n2100.arm.linux.org.uk>
References: <1319844110-23062-1-git-send-email-bfreed@chromium.org> <4EABBBD3.5030700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EABBBD3.5030700@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 29, 2011 at 10:39:47AM +0200, Marco Stornelli wrote:
> (Added linux-arm)
>
> Il 29/10/2011 01:21, Bryan Freed ha scritto:
>> I had some difficulty in getting ramoops to work on our ARM systems.
>> The driver maps memory with ioremap() which is supposed to map IO memory,
>> not physical RAM.  This happens to work on x86 and apparently some other
>> architectures, but it does not work on ARM.
>> Specifically, I see this comment in __arm_ioremap_pfn_caller():
>> 	Don't allow RAM to be mapped - this causes problems with ARMv6+
>>
>> So here is a patch that hacks around the issue using page_is_ram() to
>> differentiate between the two.
>>
>> Am I missing something here?
>> Is ramoops working on any ARM systems yet, and I am just doing something wrong?
>>
>> My ARM platform reserves a section of RAM for use by ramoops, but it is still
>> mapped along with the rest of main memory.  This is so /dev/mem can find it
>> with xlate_dev_mem_ptr().
>> On x86, I see our BIOS reserves the memory so that it is not counted as main
>> memory, and it is not mapped until ramoops ioremaps it.
>>
>> Bryan Freed (1):
>>    ramoops: Add support for ARM systems.
>>
>>   drivers/char/ramoops.c |   67 +++++++++++++++++++++++++++++++++++++----------
>>   1 files changed, 52 insertions(+), 15 deletions(-)
>>
>
> Can some ARM guys give an opinion about that?

Opinion about the patch which isn't present in this email (so we can't
see it) or about the commentry above?
