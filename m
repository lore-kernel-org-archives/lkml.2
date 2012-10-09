Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717Ab2JILFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 07:05:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:49805 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab2JILFp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 07:05:45 -0400
Message-ID: <1349780697.7880.14.camel@twins>
Subject: Re: [PATCH] task_work: avoid unneeded cmpxchg() in task_work_run()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Date: Tue, 09 Oct 2012 13:04:57 +0200
In-Reply-To: <20121008123815.GA847@redhat.com>
References: <50729A78.9090601@cn.fujitsu.com>
	 <20121008123815.GA847@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-08 at 14:38 +0200, Oleg Nesterov wrote:
> But the code looks more complex, and the only advantage is that
> non-exiting task does xchg() instead of cmpxchg(). Not sure this
> worth the trouble, in this case task_work_run() will likey run
> the callbacks (the caller checks ->task_works != NULL), I do not
> think this can add any noticeable speedup. 

Yeah, I agree, the patch doesn't seem worth the trouble. It makes tricky
code unreadable at best.

