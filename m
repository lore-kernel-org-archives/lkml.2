Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab1H2NIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 09:08:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46571 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab1H2NH6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 09:07:58 -0400
Subject: Re: [kernel.org users] [KORG] Panics on master backend
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frank Rowand <frank.rowand@am.sony.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, users@kernel.org,
        hch <hch@infradead.org>, "yong.zhang0" <yong.zhang0@gmail.com>,
        scameron@beardog.cce.hp.com, Jens Axboe <jaxboe@fusionio.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>
Date: Mon, 29 Aug 2011 15:06:56 +0200
In-Reply-To: <20110825135429.GA32048@redhat.com>
References: <4E53ECEF.7040109@kernel.org> <1314129133.8002.102.camel@twins>
	 <20110824160806.GA12317@redhat.com> <1314267872.27911.6.camel@twins>
	 <20110825135429.GA32048@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314623216.2816.25.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-25 at 15:54 +0200, Oleg Nesterov wrote:
> > Isn't us holding ->pi_lock sufficient to stabilize task_cpu()? If its a
> > running task the initial ->state check would have failed,
> 
> Of course it is not TASK_RUNNING, but it can be running or not.
> 
> > and thus its a
> > proper wakeup when we get here and thus ->pi_lock is serializing things.
> 
> I am not sure. If ->on_rq is true, we need rq->lock. Say, pull_task() can
> change its cpu. 

If its !TASK_RUNNING but ->on_rq is true, it must be current, and
pull_task() will never move current around.


