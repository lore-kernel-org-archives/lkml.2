Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab0F2LfY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 07:35:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47633 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab0F2LfV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 07:35:21 -0400
Subject: Re: [PATCH] avoid race condition in pick_next_task_fair in 
 kernel/sched_fair.c
From: Peter Zijlstra <peterz@infradead.org>
To: shenghui <crosslonelyover@gmail.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, Greg KH <greg@kroah.com>
In-Reply-To: <AANLkTik4PXpgkc_ob-INohfmlTwe3wqDmif_ohXBxHHX@mail.gmail.com>
References: <AANLkTin49UHeVhfS-iFwWvPIg29HPhXaP3DorBAa-a0I@mail.gmail.com>
	 <1277808215.1868.5.camel@laptop>
	 <AANLkTik4PXpgkc_ob-INohfmlTwe3wqDmif_ohXBxHHX@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 29 Jun 2010 13:35:16 +0200
Message-ID: <1277811316.1868.40.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-29 at 19:24 +0800, shenghui wrote:

> I wonder is there any chance set_next_entity() can get NULL for
> parameter se if so?

Well, if your machine crashes that way, maybe, but I haven't seen that
happen in a long while.

> And will you please give me some instructions on where rq->lock
> is required?

Pretty much everywhere, if you look at sched.c the only sched_class
method not called with rq->lock held is ::task_fork().

The interesting bits are that schedule()->pre_schedule()/idle_balance()
can drop rq->lock as well as ->select_task_rq().



