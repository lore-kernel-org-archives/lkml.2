Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab1HNRuv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 13:50:51 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49779 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab1HNRur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 13:50:47 -0400
MIME-Version: 1.0
In-Reply-To: <20110812094129.GO19467@legolas.emea.dhcp.ti.com>
References: <1312801266-11888-1-git-send-email-per.forlin@stericsson.com>
	<20110812094129.GO19467@legolas.emea.dhcp.ti.com>
Date: Sun, 14 Aug 2011 19:50:46 +0200
Message-ID: <CAJ0pr18rnhN2XdP4p+o=PyKLJb6470OzsOuQpcNc29jtu1hS8w@mail.gmail.com>
Subject: Re: [PATCH v2] usb: musb: ux500: optimize DMA callback routine
From: Per Forlin <per.forlin@linaro.org>
To: balbi@ti.com
Cc: Per Forlin <per.forlin@stericsson.com>,
        Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 August 2011 11:41, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Mon, Aug 08, 2011 at 01:01:06PM +0200, Per Forlin wrote:
>> From: Per Forlin <per.forlin@linaro.org>
>>
>> Skip the use of work queue and call musb_dma_completion() directly from
>> DMA callback context.
>>
>> Here follows measurements on a Snowball board with ondemand governor active.
>>
>> Performance using work queue:
>> (105 MB) copied, 6.23758 s, 16.8 MB/s
>> (105 MB) copied, 5.7151 s, 18.3 MB/s
>> (105 MB) copied, 5.83583 s, 18.0 MB/s
>> (105 MB) copied, 5.93611 s, 17.7 MB/s
>>
>> Performance without work queue
>> (105 MB) copied, 5.62173 s, 18.7 MB/s
>> (105 MB) copied, 5.61811 s, 18.7 MB/s
>> (105 MB) copied, 5.57817 s, 18.8 MB/s
>> (105 MB) copied, 5.58549 s, 18.8 MB/s
>>
>> Signed-off-by: Per Forlin <per.forlin@linaro.org>
>> Acked-by: Mian Yousaf Kaukab<mian.yousaf.kaukab@stericsson.com>
>
> this patch doesn't apply anymore:
>
> $ patch -p1 --dry-run < ~/apply.diff
> patching file drivers/usb/musb/ux500_dma.c
> Hunk #2 FAILED at 55.
> Hunk #3 succeeded at 325 (offset -4 lines).
> Hunk #4 succeeded at 341 (offset -4 lines).
> Hunk #5 succeeded at 367 (offset -4 lines).
> 1 out of 5 hunks FAILED -- saving rejects to file drivers/usb/musb/ux500_dma.c.rej
>
> care to rebase on top of 3.1-rc1. Thanks
>
I can apply the patch on top of 3.1-rc1 but it has dependency to the
patches I posted recently. This is the order the patches apply:
0001-usb-musb-ux500-set-dma-config-for-both-src-and-dst.patch
0002-usb-musb-ux500-replace-missing-DBG-with-dev_dbg.patch
0003-usb-musb-ux500-optimize-DMA-callback-routine.patch

Please let me know if I should reorder the patches. I can resend all
three in one patchset.

Thanks,
Per
