Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab2HTQCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:02:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754608Ab2HTQCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:02:32 -0400
Date: Mon, 20 Aug 2012 17:58:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt <rostedt@goodmis.org>,
        dhowells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: lockdep trace from posix timers
Message-ID: <20120820155855.GB21400@redhat.com>
References: <20120724203613.GA9637@redhat.com> <1345140478.29668.54.camel@twins> <20120817151447.GA7918@redhat.com> <1345446957.23018.14.camel@twins> <20120820154331.GA20796@redhat.com> <1345477686.23018.62.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345477686.23018.62.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20, Peter Zijlstra wrote:
>
> On Mon, 2012-08-20 at 17:43 +0200, Oleg Nesterov wrote:
> > BTW, do you think it is really important to try to avoid ->pi_lock?
>
> It is for me, I'm doing task_work_add() from under rq->lock.. :/ I could
> fudge around and delay, but not having to would be nice.

Aha, got it.

At first glance, bit_spin_lock() can work. I'll try to make the patches
tomorrow.

Oleg.

