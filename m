Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280Ab0JYRvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 13:51:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757240Ab0JYRvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 13:51:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [resend][PATCH 3/4] move cred_guard_mutex from task_struct to
	signal_struct
In-Reply-To: Oleg Nesterov's message of  Monday, 25 October 2010 19:42:20 +0200 <20101025174220.GA21375@redhat.com>
References: <20101025122538.9167.A69D9226@jp.fujitsu.com>
	<20101025122801.9170.A69D9226@jp.fujitsu.com>
	<20101025172657.A9EC9C9E3C@blackie.sf.frob.com>
	<20101025174220.GA21375@redhat.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20101025175113.963CCC9E3C@blackie.sf.frob.com>
Date: Mon, 25 Oct 2010 13:51:13 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Except: I am not sure about -stable. At least, this patch should
> not go into the <2.6.35 kernels, it relies on misc changes which
> changed the scope of task->signal. Before 2.6.35 almost any user
> of ->cred_guard_mutex can race with exit and hit ->signal == NULL.

I see no justification for a change like this in any -stable tree.  It's
just a cleanup, right?  If it's a prerequisite for the fix we like for an
"important" bug, then that's a different story.  In its own right, it's
clearly not appropriate for backporting.


Thanks,
Roland
