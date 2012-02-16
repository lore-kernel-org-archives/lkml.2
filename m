Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab2BPX22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 18:28:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37251 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922Ab2BPX21 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 18:28:27 -0500
Message-ID: <1329434900.2293.261.camel@twins>
Subject: Re: [RFC][PATCH] sched: Optimize cgroup pick_next_task_fair
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: Venkatesh Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>
Date: Fri, 17 Feb 2012 00:28:20 +0100
In-Reply-To: <1329434437.2293.259.camel@twins>
References: <1328936700.2476.17.camel@laptop>
	 <1329434437.2293.259.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-17 at 00:20 +0100, Peter Zijlstra wrote:
> +       if (prev && (prev->sched_class != &fair_sched_class ||
> +                               cfs_rq->nr_running == 1)) { 

this ==1 check is way ugly and a problem that needs addressing. Not
putting cfs_rq->curr back in the tree perturbs pick_next_entity()'s view
of things.

Probably easiest to pick leftmost and ->curr and go from there, but
that's for tomorrow or so.
