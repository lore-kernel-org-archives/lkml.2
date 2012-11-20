Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab2KTRyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 12:54:11 -0500
Received: from mail.vyatta.com ([76.74.103.46]:59714 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905Ab2KTRyK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 12:54:10 -0500
Date: Tue, 20 Nov 2012 09:53:04 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Paolo Valente <paolo.valente@unimore.it>
Cc: David Miller <davem@davemloft.net>, jhs@mojatatu.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        rizzo@iet.unipi.it, fchecconi@gmail.com
Subject: Re: [PATCH] pkt_sched: QFQ Plus: fair-queueing service at DRR cost
Message-ID: <20121120095304.420ded7c@nehalam.linuxnetplumber.net>
In-Reply-To: <50ABC19E.9030209@unimore.it>
References: <20121112164833.GA12970@paolo-ThinkPad-W520>
	<20121119.184828.628106002307042971.davem@davemloft.net>
	<50ABC19E.9030209@unimore.it>
Organization: Vyatta
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2012 18:45:02 +0100
Paolo Valente <paolo.valente@unimore.it> wrote:

> Il 20/11/2012 00:48, David Miller ha scritto:
> > From: Paolo Valente <paolo.valente@unimore.it>
> > Date: Mon, 12 Nov 2012 17:48:33 +0100
> >
> >> [This patch received positive feedback from Stephen Hemminger ("put in
> >> net-next"), but no further feedback or decision. So I am (re)sending
> >> an updated version of it. The only differences with respect to the
> >> previous version are the support for TSO/GSO (taken from QFQ), and a
> >> hopefully improved description.]
> >
> > Can you rearrange the logic so that the compiler doesn't emit this
> > warning?
> >
> > In file included from net/sched/sch_qfq.c:18:0:
> > net/sched/sch_qfq.c: In function ¡qfq_dequeue¢:
> > include/net/sch_generic.h:480:15: warning: ¡skb¢ may be used uninitialized in this function [-Wmaybe-uninitialized]
> > net/sched/sch_qfq.c:1007:18: note: ¡skb¢ was declared here
> >
> > You and I both know that SKB will be initialized at this point, but
> > the compiler can't see it clearly enough.
> >
> Unfortunately I could not reproduce the warning (with
> gcc-4.7 -Wmaybe-uninitialized). I am however about to send a new version 
> with skb initialized to NULL. I hope that this fix properly addresses 
> this issue.

There are actually lots of bogus warnings than seem to only occur
because gcc 4.4 does a bad job of checking. Later versions are fixed
and don't generate warnings.

My preference is to not add the unnecessary initialization because
if you get in the habit of doing it. The whole purpose of the uninitialized
check is lost. 

