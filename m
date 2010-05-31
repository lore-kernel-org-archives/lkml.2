Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab0EaKBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 06:01:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48356 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab0EaKBR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 06:01:17 -0400
Subject: Re: [PATCH 2/4] sched: implement __set_cpus_allowed()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Galbraith <efault@gmx.de>
In-Reply-To: <4C03879A.8030505@kernel.org>
References: <1273747705-7829-1-git-send-email-tj@kernel.org>
	 <1273747705-7829-3-git-send-email-tj@kernel.org>
	 <1275292866.27810.21441.camel@twins>  <4C03879A.8030505@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 31 May 2010 12:01:24 +0200
Message-ID: <1275300084.27810.21850.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-31 at 11:55 +0200, Tejun Heo wrote:
> I don't think flushing from CPU_UP_PREPARE would be a good idea.
> There is no guarantee that those works will finish in short (human
> scale) time,

If not, we should cure it by ensuring these works won't be left
lingering I think.

Also, I really don't much care about how fast we can hotplug cycle
things -- its an utter slow path.

>  but we can update cpu_active mask before other
> CPU_UP_PREPARE notifiers are executed so that it's symmetrical to cpu
> down path and then this problem goes away the exact same way, right?

Ah, no, we cannot mark it active before its actually up, because at that
time we'll actually try and run stuff on it, which clearly won't work
when its not there to run stuff.
