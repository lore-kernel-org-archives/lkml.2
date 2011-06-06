Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264Ab1FFNne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 09:43:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:48913 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757234Ab1FFNn2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 09:43:28 -0400
Subject: Re: [PATCH] sched: RCU-protect __set_task_cpu() in set_task_cpu()
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110605191233.GA20462@redhat.com>
References: <20110531172651.GA4478@swordfish.minsk.epam.com>
	 <1307115427.2353.3456.camel@twins>  <20110605191233.GA20462@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 06 Jun 2011 15:43:22 +0200
Message-ID: <1307367802.2322.124.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-06-05 at 21:12 +0200, Oleg Nesterov wrote:
> 
>         WARN_ON_ONCE(debug_locks && !lockdep_is_held(p->on_rq ?
>                                         &task_rq(p)->lock : &p->pi_lock))
> 
> Not that I really suggest to change this WARN_ON(), I am just trying
> to recall the new rules. 

I actually like that, so I tried it, we need to clean up some of the
fork() path hacks but it should be possible. Will try and remember for
the next release or so.
