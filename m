Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702Ab2ECQW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 12:22:57 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:42793 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757576Ab2ECQWz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 12:22:55 -0400
MIME-Version: 1.0
In-Reply-To: <x49fwbhl48d.fsf@segfault.boston.devel.redhat.com>
References: <1336054995-22988-1-git-send-email-svenkatr@ti.com>
 <1336054995-22988-7-git-send-email-svenkatr@ti.com> <x49fwbhl48d.fsf@segfault.boston.devel.redhat.com>
From: "S, Venkatraman" <svenkatr@ti.com>
Date: Thu, 3 May 2012 21:52:32 +0530
Message-ID: <CANfBPZ-V86XfnA8CXVsupvWkfnXPC7upCqAFsx8+_2Ta5zTabA@mail.gmail.com>
Subject: Re: [PATCH v2 06/16] block: treat DMPG and SWAPIN requests as special
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-mmc@vger.kernel.org, cjb@laptop.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd.bergmann@linaro.org,
        alex.lemberg@sandisk.com, ilan.smith@sandisk.com, lporzio@micron.com,
        rmk+kernel@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 3, 2012 at 8:08 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Venkatraman S <svenkatr@ti.com> writes:
>
>> From: Ilan Smith <ilan.smith@sandisk.com>
>>
>> When exp_swapin and exp_dmpg are set, treat read requests
>> marked with DMPG and SWAPIN as high priority and move to
>> the front of the queue.
>>
> [...]
>> +     if (bio_swapin(bio) && blk_queue_exp_swapin(q)) {
>> +             spin_lock_irq(q->queue_lock);
>> +             where = ELEVATOR_INSERT_FLUSH;
>> +             goto get_rq;
>> +     }
>> +
>> +     if (bio_dmpg(bio) && blk_queue_exp_dmpg(q)) {
>> +             spin_lock_irq(q->queue_lock);
>> +             where = ELEVATOR_INSERT_FLUSH;
>> +             goto get_rq;
>
> Is ELEVATOR_INSERT_FRONT not good enough?  It seems wrong to use _FLUSH,
> here.  If the semantics of ELEVATOR_INSERT_FLUSH are really what is
> required, then perhaps we need to have another think about the naming of
> these flags.
>
Actually - yes, ELEVATOR_INSERT_FRONT would do as well. In the
previous version of MMC stack,
we needed the _FLUSH to trigger the write operation that was to be
preempted, to check that
it actually works.


> Cheers,
> Jeff
>
> --
