Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702Ab2GZIRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 04:17:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36185 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab2GZIRs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 04:17:48 -0400
Message-ID: <1343290631.26034.86.camel@twins>
Subject: Re: [PATCH 2/2] sched: fix a logical error in select_task_rq_fair
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Date: Thu, 26 Jul 2012 10:17:11 +0200
In-Reply-To: <1343280446-24019-2-git-send-email-alex.shi@intel.com>
References: <1343280446-24019-1-git-send-email-alex.shi@intel.com>
	 <1343280446-24019-2-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-26 at 13:27 +0800, Alex Shi wrote:
> If find_idlest_cpu() return '-1', and sd->child is NULL. The function
> select_task_rq_fair will return -1. That is not the function's purpose.

But find_idlest_cpu() will only return -1 if the group mask is fully
excluded by the cpus_allowed mask, right?

In that case aren't we covering up a bug in find_idlest_group(), it
appears to have returned a group that isn't eligible to be idlest.


