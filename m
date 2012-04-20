Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab2DTMHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 08:07:05 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:37988 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab2DTMHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 08:07:02 -0400
Date: Fri, 20 Apr 2012 14:06:54 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Bas van der Oest <bassvdo@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: /proc/stat information incorrect
Message-ID: <20120420140654.793a40f2@de.ibm.com>
In-Reply-To: <CABWpNyaw3Xq7FJ4A0itYEFLN1QdwBvvqs0rVxB1z-cyaUcmuVw@mail.gmail.com>
References: <CABWpNyZkL8K3R=ObOvV9SGMVGTcs1R83H0LSWyXFrQ-Wwb5p+w@mail.gmail.com>
	<20120416143606.2ee7c571@de.ibm.com>
	<CABWpNyaw3Xq7FJ4A0itYEFLN1QdwBvvqs0rVxB1z-cyaUcmuVw@mail.gmail.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12042012-5024-0000-0000-000002515121
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2012 10:04:35 +0200
Bas van der Oest <bassvdo@gmail.com> wrote:

> > Assuming that you are on a recent kernel (>= 3.2), could you please
> > try to revoke git commit a25cac5198d4ff28 "proc: Consider NO_HZ when
> > printing idle and iowait times" and try again ?
> 
> I revoked the patch and this certainly had effect, however I still
> doubt if the result is completely correct now.
> It now seems that CPU4 (this one is handling the irqs now) spends more
> time than the other CPUs:
> 
>         user    nice    system  idle    iowait  irq   softirq sum
> cpu     4       0       412     8186    0       0       79      8681
> cpu0    0       0       1       1074    0       0       1       1076
> cpu1    0       0       2       1075    0       0       0       1077
> cpu2    0       0       1       1075    0       0       0       1076
> cpu3    0       0       1       1079    0       0       0       1080
> cpu4    1       0       115     941     0       0       78      1135
> cpu5    2       0       99      984     0       0       0       1085
> cpu6    0       0       98      977     0       0       0       1075
> cpu7    0       0       95      980     0       0       0       1075
> 
> Any suggestions where this small difference is coming from?

CONFIG_IRQ_TIME_ACCOUNTING comes to mind. Is this enabled for your
kernel ?

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

