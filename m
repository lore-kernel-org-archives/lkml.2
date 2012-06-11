Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab2FKRUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 13:20:19 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:43675 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751688Ab2FKRUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 13:20:17 -0400
MIME-Version: 1.0
In-Reply-To: <780c1dad11fe08de17a3ff41b22ba3b8.squirrel@www.codeaurora.org>
References: <1338576911-17089-1-git-send-email-merez@codeaurora.org>
 <1338576911-17089-2-git-send-email-merez@codeaurora.org> <007c01cd455a$56392050$02ab60f0$%jun@samsung.com>
 <780c1dad11fe08de17a3ff41b22ba3b8.squirrel@www.codeaurora.org>
From: "S, Venkatraman" <svenkatr@ti.com>
Date: Mon, 11 Jun 2012 22:49:53 +0530
Message-ID: <CANfBPZ-HukGqES4eUhxfDhLy+Sj6XJEyPu9kgKCAddPnVyoqKA@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] mmc: block: Add write packing control
To: merez@codeaurora.org
Cc: Seungwon Jeon <tgih.jun@samsung.com>, linux-mmc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        "DOCUMENTATION'" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 9, 2012 at 8:16 PM,  <merez@codeaurora.org> wrote:
>
>> Hi,
>>
>> How can we check the effect?
>> Do you have any result?
> We ran parallel lmdd read and write operations and found out that the
> write packing causes the read throughput to drop from 24MB/s to 12MB/s.

Whoa! That's a big drop.
BTW, is there a problem with throughput or latency, or both ?
If these numbers are over long duration (>5 seconds), then where are
the cycles going?
It would be nice to see some blktrace figures for the issue, and then fix it,
rather than apply a band aid like the write-packing-control on top..


> The write packing control managed to increase the read throughput back to
> the original value.
> We also examined "real life" scenarios, such as performing a big push
> operation in parallel to launching several applications. We measured the
> read latency and found out that with the write packing control the worst
> case of the read latency was smaller.
>
>> Please check the several comment below.
>>
>> Maya Erez <merez@codeaurora.org> wrote:
>>> The write packing control will ensure that read requests latency is
>>> not increased due to long write packed commands.
>>>
>>> The trigger for enabling the write packing is managing to pack several
>>> write requests. The number of potential packed requests that will
>>> trigger
>>> the packing can be configured via sysfs by writing the required value
>>> to:
>>> /sys/block/<block_dev_name>/num_wr_reqs_to_start_packing.
>>> The trigger for disabling the write packing is fetching a read request.
>>>
