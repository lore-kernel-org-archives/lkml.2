Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289Ab2KZWcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 17:32:55 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52896 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194Ab2KZWcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 17:32:54 -0500
Date: Mon, 26 Nov 2012 14:32:49 -0800
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
        Paul Menage <paul@paulmenage.org>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Why is cpuset_cpus_allowed_fallback() necessary?
Message-ID: <20121126223249.GB15930@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

I'm wondering why cpuset_cpus_allowed_fallback() is necessary.  This
is called from, e.g., try_to_wake_up()->select_task_rq() when none of
the cpus in ->cpus_allowed is useable.  The cpuset callback invokes
do_set_cpus_allowed() w/ the cpuset's cpus_allowed.  This was added by
the following commit,

  commit 9084bb8246ea935b98320554229e2f371f7f52fa
  Author: Oleg Nesterov <oleg@redhat.com>
  Date:   Mon Mar 15 10:10:27 2010 +0100


  sched: Make select_fallback_rq() cpuset friendly

  Introduce cpuset_cpus_allowed_fallback() helper to fix the cpuset problems
  with select_fallback_rq(). It can be called from any context and can't use
  any cpuset locks including task_lock(). It is called when the task doesn't
  have online cpus in ->cpus_allowed but ttwu/etc must be able to find a
  suitable cpu.
  ....			  

The problem is, nothing's explaining what "the cpuset problems with
select_fallback_rq()" are.  Oleg, do you remember?  Why do we need
this?

Thanks.

-- 
tejun
