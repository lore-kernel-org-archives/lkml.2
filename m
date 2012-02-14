Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760331Ab2BNM71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 07:59:27 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51101 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab2BNM70 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 07:59:26 -0500
MIME-Version: 1.0
In-Reply-To: <CADZ9YHhGWd9DToiQDbvv4=BvN4DZLJMuvyLNUHjWqErGE3nXzQ@mail.gmail.com>
References: <CADZ9YHhOfVm7qNj6oznmRCUuyyA4BQfmsd-M7FzrmWB9SxMgzg@mail.gmail.com>
	<CAJd=RBD+x8SHkMPqxRGwmm90wvj2b_2bAdexxo6w39_ngGgHdA@mail.gmail.com>
	<CADZ9YHhGWd9DToiQDbvv4=BvN4DZLJMuvyLNUHjWqErGE3nXzQ@mail.gmail.com>
Date: Tue, 14 Feb 2012 20:59:25 +0800
Message-ID: <CAJd=RBAAe212McM=26UDAt8_zrZgJFQewFjRyby2Za5m_Z+FDg@mail.gmail.com>
Subject: Re: [ANNOUNCEMENT] The Barbershop Load Distribution algorithm for
 Linux kernel scheduler.
From: Hillf Danton <dhillf@gmail.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 1:22 AM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
>>> +
>>> +       if (rq->pos != 2) {     /* if rq isn't the last one */
>>> +               struct rq *last;
>>> +               write_lock_irqsave(&disp_list_lock, flag);
>>
>>                    if (rq->pos != 2)
>>                             goto out;
>>
> At this point, we're checking whether this task is activating on a rq
> which is the last (hightest loaded) rq or not. If rq->pos != 2, it
> stands we're not activating a task at the highest loaded rq, so a
> check will be made with the highest loaded rq to make sure - this rq's
> loaded didn't exceed the highest loaded rq. If rq's load
> exceed - list will be removed from it's place and will be placed as a
> last entry of rq_head and thus it becomes the highest loaded rq. So,
> what you proposed here isn't what was intended.
>

I want to say
                    if (rq->pos == 2)
                             goto out;
sorry for the bad:(

> Hiff, did you ran the patch? Would like to know.

Try to run soon.

Best regards
Hillf
