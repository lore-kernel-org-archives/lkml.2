Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418Ab2HPIWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 04:22:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36268 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab2HPIWG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 04:22:06 -0400
Message-ID: <1345105317.29668.1.camel@twins>
Subject: Re: [PATCH 1/1] sched: unthrottle rt runqueues in
 __disable_runtime()
From: Peter Zijlstra <peterz@infradead.org>
To: Peter Boonstoppel <pboonstoppel@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Date: Thu, 16 Aug 2012 10:21:57 +0200
In-Reply-To: <5FBF8E85CA34454794F0F7ECBA79798F379D3648B7@HQMAIL04.nvidia.com>
References: <5FBF8E85CA34454794F0F7ECBA79798F379D3648B7@HQMAIL04.nvidia.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-09 at 15:34 -0700, Peter Boonstoppel wrote:
> migrate_tasks() uses _pick_next_task_rt() to get tasks from the
> real-time runqueues to be migrated. When rt_rq is throttled
> _pick_next_task_rt() won't return anything, in which case
> migrate_tasks() can't move all threads over and gets stuck in an
> infinite loop.
> 
> Instead unthrottle rt runqueues before migrating tasks.
> 
> Additionally: move unthrottle_offline_cfs_rqs() to rq_offline_fair()

Thanks!
