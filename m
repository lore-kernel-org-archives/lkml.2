Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab2DPMgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 08:36:19 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:34665 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab2DPMgP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 08:36:15 -0400
Date: Mon, 16 Apr 2012 14:36:06 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Bas van der Oest <bassvdo@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: /proc/stat information incorrect
Message-ID: <20120416143606.2ee7c571@de.ibm.com>
In-Reply-To: <CABWpNyZkL8K3R=ObOvV9SGMVGTcs1R83H0LSWyXFrQ-Wwb5p+w@mail.gmail.com>
References: <CABWpNyZkL8K3R=ObOvV9SGMVGTcs1R83H0LSWyXFrQ-Wwb5p+w@mail.gmail.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
x-cbid: 12041612-3548-0000-0000-000001A1718C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2012 10:04:48 +0200
Bas van der Oest <bassvdo@gmail.com> wrote:

> After dropping some zero columns and taking the difference between the
> statistics the reformatted result is:
>        user    nice    system  idle    iowait  irq     softirq sum
> cpu     5       0       434     7676    0       0       53      8168
> cpu0    0       0       0       1067    0       0       0       1067
> cpu1    0       0       1       1070    0       0       0       1071
> cpu2    0       0       0       1071    0       0       0       1071
> cpu3    1       0       0       1070    0       0       0       1071
> cpu4    1       0       94      974     0       0       0       1069
> cpu5    2       0       92      535     0       0       52      681
> cpu6    0       0       82      987     0       0       0       1069
> cpu7    1       0       165     905     0       0       0       1071
> 
> I added a sum column which totals the time spent in the different
> modes. The above table now shows how long each CPU was in what mode
> for how long.
> Now I am wondering how it is possible that CPU5 has spent much less
> time than all the other CPUs. I expected that all CPUs spent around
> the same time (10s). This time includes idle time so this is not
> related to the difference in active/idle CPUs.
> 
> I know for a fact that this effect is related to which CPU is handling
> my IRQs; this effect happens to all CPUs if I map the interrupts to
> that particular CPU.
> I looked up the scheduler's statistics handling in the kernel source
> but was not able to find any cause for the above mentioned effect.
> 
> Can anyone reproduce this behaviour?
> Does anyone know where/what might be the cause of this?

Assuming that you are on a recent kernel (>= 3.2), could you please
try to revoke git commit a25cac5198d4ff28 "proc: Consider NO_HZ when
printing idle and iowait times" and try again ?

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

