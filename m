Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab0FUUEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 16:04:13 -0400
Received: from smtp-out.google.com ([74.125.121.35]:55282 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab0FUUEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 16:04:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=yqM1R8FX6CsL/ihdVOB5SYUIAO+zL9BBxnHPqz0ch7D+9Ci0vRWur2/OBxplvWZEb
	jQdkBNcv7YQtDH7D+pL8w==
Date: Mon, 21 Jun 2010 13:04:05 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 4/9] oom: oom_kill_process() need to check p is
 unkillable
In-Reply-To: <20100617135224.FBAA.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1006211301110.8367@chino.kir.corp.google.com>
References: <20100617104647.FB89.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1006162118520.14101@chino.kir.corp.google.com> <20100617135224.FBAA.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jun 2010, KOSAKI Motohiro wrote:

> > > When oom_kill_allocating_task is enabled, an argument task of
> > > oom_kill_process is not selected by select_bad_process(), It's
> > > just out_of_memory() caller task. It mean the task can be
> > > unkillable. check it first.
> > > 
> > 
> > This should be unnecessary if oom_kill_process() appropriately returns 
> > non-zero when it cannot kill a task.  What problem are you addressing with 
> > this fix?
> 
> oom_kill_process() only check its children are unkillable, not its own.

No, oom_kill_process() returns the value of oom_kill_task(victim) which is 
non-zero for !victim->mm in mmotm-2010-06-11-16-40 (and 2.6.34 although 
victim == p in that case).
