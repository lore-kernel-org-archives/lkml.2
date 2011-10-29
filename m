Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab1J2Ipy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 04:45:54 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56945 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab1J2Ipw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 04:45:52 -0400
Message-ID: <4EABBBD3.5030700@gmail.com>
Date: Sat, 29 Oct 2011 10:39:47 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: linux-arm-kernel@lists.infradead.org
CC: Bryan Freed <bfreed@chromium.org>, linux-kernel@vger.kernel.org,
        sergiu@chromium.org, akpm@linux-foundation.org, msb@chromium.org,
        seiji.aguchi@hds.com
Subject: Re: [PATCH] ramoops appears geared to not support ARM
References: <1319844110-23062-1-git-send-email-bfreed@chromium.org>
In-Reply-To: <1319844110-23062-1-git-send-email-bfreed@chromium.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Added linux-arm)

Il 29/10/2011 01:21, Bryan Freed ha scritto:
> I had some difficulty in getting ramoops to work on our ARM systems.
> The driver maps memory with ioremap() which is supposed to map IO memory,
> not physical RAM.  This happens to work on x86 and apparently some other
> architectures, but it does not work on ARM.
> Specifically, I see this comment in __arm_ioremap_pfn_caller():
> 	Don't allow RAM to be mapped - this causes problems with ARMv6+
>
> So here is a patch that hacks around the issue using page_is_ram() to
> differentiate between the two.
>
> Am I missing something here?
> Is ramoops working on any ARM systems yet, and I am just doing something wrong?
>
> My ARM platform reserves a section of RAM for use by ramoops, but it is still
> mapped along with the rest of main memory.  This is so /dev/mem can find it
> with xlate_dev_mem_ptr().
> On x86, I see our BIOS reserves the memory so that it is not counted as main
> memory, and it is not mapped until ramoops ioremaps it.
>
> Bryan Freed (1):
>    ramoops: Add support for ARM systems.
>
>   drivers/char/ramoops.c |   67 +++++++++++++++++++++++++++++++++++++----------
>   1 files changed, 52 insertions(+), 15 deletions(-)
>

Can some ARM guys give an opinion about that?

Thanks.

Marco
