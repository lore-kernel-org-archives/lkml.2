Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab2FGNLI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 09:11:08 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:39023 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757580Ab2FGNLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 09:11:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAJd=RBCa_JfHO-=HiGqz_13CaHj5KGE5-EYAYT3jd+FPofqybw@mail.gmail.com>
References: <CAJd=RBB1s-_VOtoDsBbLidS51HwW6e98p=U-4mL-spByUMvETw@mail.gmail.com>
	<CA+i8gKKQyGBc-BNBJ72S6rq7aiFqS=onqWQyeY4P+VVvFCeXJw@mail.gmail.com>
	<CAJd=RBA=mvMGQgdKgW26dgd8nK2-_dW_epQLwbjOo2Zx2gsbeg@mail.gmail.com>
	<CA+i8gK+H-hm9bjJub4siH0pCdOrzRxJXaX2QjosnKCjeWYPt4A@mail.gmail.com>
	<CAJd=RBBxnD7JirPpy-jTgE9kpnZXN6gkTMsgcG8=goZxgQfTaQ@mail.gmail.com>
	<CA+i8gKLrd4JUf5P=zkj4x_yYc-kk2kjA-0To9e7iRNbZcCpLxA@mail.gmail.com>
	<CAJd=RBCa_JfHO-=HiGqz_13CaHj5KGE5-EYAYT3jd+FPofqybw@mail.gmail.com>
Date: Thu, 7 Jun 2012 21:05:01 +0800
Message-ID: <CAJd=RBC7r+a8Q6XvQX5-=0h2d5==tOjyG1HY_1q6=gfBwbWtFw@mail.gmail.com>
Subject: Re: [patch] BFS 420: a tiny step forward
From: Hillf Danton <dhillf@gmail.com>
To: Emmanuel Benisty <benisty.e@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Manuel Krause <manuelkrause@t-online.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 7, 2012 at 8:37 PM, Hillf Danton <dhillf@gmail.com> wrote:
> Hi Emmanuel
>
> On Wed, Jun 6, 2012 at 11:51 PM, Emmanuel Benisty <benisty.e@gmail.com> wrote:
>>
>> Unfortunately, the issue is still there.
>>
> Hang at same place?
>
And try to revert handling CPU_ONLINE, please.


--- a/kernel/sched/bfs.c	Sat Jun  2 17:30:28 2012
+++ b/kernel/sched/bfs.c	Thu Jun  7 20:58:36 2012
@@ -5352,7 +5352,7 @@ migration_call(struct notifier_block *nf
 		/* Update our root-domain */
 		grq_lock_irqsave(&flags);
 		if (rq->rd) {
-			BUG_ON(cpumask_test_cpu(cpu, rq->rd->span));
+			BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));

 			set_rq_online(rq);
 		}
--
