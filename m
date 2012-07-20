Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab2GTQkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 12:40:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48530 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab2GTQkS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 12:40:18 -0400
Message-ID: <1342802391.2583.11.camel@twins>
Subject: Re: [PATCHSET] workqueue: reimplement CPU hotplug to keep idle
 workers
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, linux-pm@vger.kernel.org
Date: Fri, 20 Jul 2012 18:39:51 +0200
In-Reply-To: <1342545149-3515-1-git-send-email-tj@kernel.org>
References: <1342545149-3515-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-17 at 10:12 -0700, Tejun Heo wrote:
> Currently, workqueue destroys all workers for offline CPUs unless
> there are lingering work items. 

_that_ is the root of all ugly in that thing. I still find it utterly
insane you can create 'per-cpu' workqueues and then violate the per-cpu
property with hotplug and get your work ran on a different CPU.

It should be a hard error to use queue_work_on() and then run the work
on a different cpu. Yet somehow this isn't so.
