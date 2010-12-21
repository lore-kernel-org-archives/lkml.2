Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860Ab0LUQHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 11:07:04 -0500
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:36385 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751434Ab0LUQHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 11:07:03 -0500
Subject: Re: [V2 PATCH] kthread_work: Make lockdep happy
From: Andy Walls <awalls@md.metrocast.net>
To: Tejun Heo <tj@kernel.org>
Cc: Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org,
        nicolas.mailhot@laposte.net, Jarod Wilson <jarod@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20101221125934.GA13285@htj.dyndns.org>
References: <1292762975.2403.29.camel@localhost>
	 <AANLkTimYx2Og1BG37wb0WZ0_U8WJjLKHMKgU45qycUaM@mail.gmail.com>
	 <AANLkTikuKMLUoVnQsU6QNCnHBgOponJUngHGtyVHk1xK@mail.gmail.com>
	 <4D0F8276.9070903@kernel.org> <20101221044050.GA25718@windriver.com>
	 <20101221125934.GA13285@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Dec 2010 11:07:08 -0500
Message-ID: <1292947628.14806.3.camel@morgan.silverblock.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-12-21_06:2010-12-21,2010-12-21,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1010190000 definitions=main-1012210061
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-21 at 13:59 +0100, Tejun Heo wrote:
> Hello,
> 
> On Tue, Dec 21, 2010 at 12:40:50PM +0800, Yong Zhang wrote:
> > From: Yong Zhang <yong.zhang0@gmail.com>
> > Subject: [V2 PATCH] kthread_work: Make lockdep happy
> > 
> > spinlock in kthread_worker and wait_queue_head in kthread_work
> > both should be lockdep sensible.
> > So change the interface to make it suiltable for CONFIG_LOCKDEP.
> > 
> > Reported-by: Nicolas <nicolas.mailhot@laposte.net>
> > Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Andy Walls <awalls@md.metrocast.net>
> > ---
> > Changes from V1:
> >  *According to Tejun, kthread_worker could be defined on stack,
> >   So introduce DEFINE_KTHREAD_WORKER_ONSTACK.
> >  *Change wrong setting to kthread_work->task. Thanks Adny for
> >   pointing it.
> >  *including some minor issue.
> > 
> > BTW, only passed build.
> 
> If somebody can confirm this makes lockdep behave correctly, I'll
> route it through the wq tree.

I will attempt to test later tonight with at least one ivtv (PVR-350)
card installed.  If I have time, I'll test with two cards (PVR-350 and
PVR-150) installed in the machine, since that will create two different
kthread_workers, each with their own lock.

How can I dump information on lockdep spinlock tracking to verify that
the two distinct locks are tracked separately by lockdep?

Regards,
Andy

