Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab2KSXsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 18:48:32 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:34481 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab2KSXsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 18:48:30 -0500
Date: Mon, 19 Nov 2012 18:48:28 -0500 (EST)
Message-Id: <20121119.184828.628106002307042971.davem@davemloft.net>
To: paolo.valente@unimore.it
Cc: jhs@mojatatu.com, shemminger@vyatta.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rizzo@iet.unipi.it, fchecconi@gmail.com
Subject: Re: [PATCH] pkt_sched: QFQ Plus: fair-queueing service at DRR cost
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121112164833.GA12970@paolo-ThinkPad-W520>
References: <20121112164833.GA12970@paolo-ThinkPad-W520>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAJNmaBX018158

From: Paolo Valente <paolo.valente@unimore.it>
Date: Mon, 12 Nov 2012 17:48:33 +0100

> [This patch received positive feedback from Stephen Hemminger ("put in
> net-next"), but no further feedback or decision. So I am (re)sending
> an updated version of it. The only differences with respect to the
> previous version are the support for TSO/GSO (taken from QFQ), and a
> hopefully improved description.]

Can you rearrange the logic so that the compiler doesn't emit this
warning?

In file included from net/sched/sch_qfq.c:18:0:
net/sched/sch_qfq.c: In function ¡qfq_dequeue¢:
include/net/sch_generic.h:480:15: warning: ¡skb¢ may be used uninitialized in this function [-Wmaybe-uninitialized]
net/sched/sch_qfq.c:1007:18: note: ¡skb¢ was declared here

You and I both know that SKB will be initialized at this point, but
the compiler can't see it clearly enough.

Thanks.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
