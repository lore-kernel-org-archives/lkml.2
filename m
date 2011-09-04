Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab1IDUc6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 16:32:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348Ab1IDUcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 16:32:52 -0400
Date: Sun, 4 Sep 2011 22:29:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, eric.dumazet@gmail.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/4] posix-timers: turn it_signal into it_valid flag
Message-ID: <20110904202907.GA3404@redhat.com>
References: <1314661157-22173-1-git-send-email-andi@firstfloor.org> <1314661157-22173-4-git-send-email-andi@firstfloor.org> <alpine.LFD.2.02.1109021135270.2723@ionos> <20110904165658.GA23948@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110904165658.GA23948@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04, Oleg Nesterov wrote:
>
> Although I
> feel this all can be simplified even more.

And perhaps we need some fixes?

I forgot everything I knew about ->it_requeue_pending logic, but it
seems to me that do_schedule_next_timer()->lock_timer() can find and
lock successfully the wrong timer. Another thread can do timer_delete()
and then re-create the timer with the same id.

Oleg.

