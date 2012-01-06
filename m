Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716Ab2AFOZN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 09:25:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302Ab2AFOZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 09:25:12 -0500
Date: Fri, 6 Jan 2012 15:19:15 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special
	condition
Message-ID: <20120106141915.GA21150@redhat.com>
References: <20120106192256.AB15.E1E9C6FF@jp.fujitsu.com> <1325847671.2442.7.camel@twins> <20120106210108.AB18.E1E9C6FF@jp.fujitsu.com> <1325853838.2442.18.camel@twins> <20120106141258.GB19462@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120106141258.GB19462@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06, Oleg Nesterov wrote:
>
> But this makes me worry. We are doing a lot of things after
> exit_mm(). In particular we take tasklist_lock in exit_notify()
> and then do_exit() takes task_lock(). But every unlock + lock
> implies mb(). So how it was possible to hit this bug???

Damn. please ignore me.

Somehow I forgot that _there is no_ spin_unlock_wait() in the
current code ;)

Oleg.

