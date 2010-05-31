Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab0EaKCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 06:02:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52656 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab0EaKCg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 06:02:36 -0400
Subject: Re: [PATCH 2/4] sched: implement __set_cpus_allowed()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Galbraith <efault@gmx.de>
In-Reply-To: <1275300084.27810.21850.camel@twins>
References: <1273747705-7829-1-git-send-email-tj@kernel.org>
	 <1273747705-7829-3-git-send-email-tj@kernel.org>
	 <1275292866.27810.21441.camel@twins>  <4C03879A.8030505@kernel.org>
	 <1275300084.27810.21850.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 31 May 2010 12:02:45 +0200
Message-ID: <1275300165.27810.21858.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-31 at 12:01 +0200, Peter Zijlstra wrote:
> >  but we can update cpu_active mask before other
> > CPU_UP_PREPARE notifiers are executed so that it's symmetrical to cpu
> > down path and then this problem goes away the exact same way, right?
> 
> Ah, no, we cannot mark it active before its actually up, because at that
> time we'll actually try and run stuff on it, which clearly won't work
> when its not there to run stuff. 

So we should clear it _before_ we go down, and set it _after_ we're up.


