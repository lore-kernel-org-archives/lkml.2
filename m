Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440Ab2EIOHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:07:23 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:44401 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758296Ab2EIOHU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:07:20 -0400
MIME-Version: 1.0
In-Reply-To: <3f7a217a08fd2c508576cbac8d26b017.squirrel@www.codeaurora.org>
References: <1336054995-22988-1-git-send-email-svenkatr@ti.com>
 <1336054995-22988-15-git-send-email-svenkatr@ti.com> <3f7a217a08fd2c508576cbac8d26b017.squirrel@www.codeaurora.org>
From: "S, Venkatraman" <svenkatr@ti.com>
Date: Wed, 9 May 2012 19:36:57 +0530
Message-ID: <CANfBPZ-ZAJjDcy6cR7q+n7SKGc+2dMYfFREg-6ovh+E1eNbGWg@mail.gmail.com>
Subject: Re: [PATCH v2 14/16] mmc: block: Implement HPI invocation and
 handling logic.
To: kdorfman@codeaurora.org
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

On Wed, May 9, 2012 at 2:05 PM,  <kdorfman@codeaurora.org> wrote:
>
>> +static bool mmc_can_do_foreground_hpi(struct mmc_queue *mq,
>> +                     struct request *req, unsigned int thpi)
>> +{
>> +
>> +     /*
>> +      * If some time has elapsed since the issuing of previous write
>> +      * command, or if the size of the request was too small, there's
>> +      * no point in preempting it. Check if it's worthwhile to preempt
>> +      */
>> +     int time_elapsed = jiffies_to_msecs(jiffies -
>> +                     mq->mqrq_cur->mmc_active.mrq->cmd->started_time);
>> +
>> +     if (time_elapsed <= thpi)
>> +                     return true;
> Some host controllers (or DMA) has possibility to get the byte count of
> current transaction. It may be implemented as host api (similar to abort
> ops). Then you have more accurate estimation of worthiness.
>

Byte count returned by DMA or the HC doesn't mean that the data has
actually been
burnt into the device (due to internal buffering). This is one of the
reasons for
defining the CORRECTLY_PRG_SECTORS_NUM register in the standard which
can be queried to find how much was correctly written.
 Unfortunately it can only be queried after the abort has been issued.

>> +
>> +     return false;
>> +}
>
> Thanks, Kostya
>
