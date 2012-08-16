Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619Ab2HPN4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 09:56:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39749 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932587Ab2HPN4f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 09:56:35 -0400
Message-ID: <1345125384.29668.30.camel@twins>
Subject: Re: Add rq->nr_uninterruptible count to dest cpu's rq while CPU
 goes down.
From: Peter Zijlstra <peterz@infradead.org>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org,
        paulmck <paulmck@linux.vnet.ibm.com>
Date: Thu, 16 Aug 2012 15:56:24 +0200
In-Reply-To: <1345124749.31092.2.camel@localhost.localdomain>
References: <1345124749.31092.2.camel@localhost.localdomain>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-16 at 19:45 +0600, Rakib Mullick wrote:
> When a CPU is about to go down, it moves all it's sleeping task to an active CPU, then nr_uninterruptible counts are
> also moved. When moving nr_uninterruptible count, currently it chooses a randomly picked CPU from the active CPU mask
> to keep the global nr_uninterruptible count intact. But, it would be precise to move nr_uninterruptible counts to the
> CPU where all the sleeping tasks were moved and it also might have subtle impact over rq's load calculation. So, this
> patch is prepared to address this issue.

The Changelog is ill-formated. Other than that, the patch doesn't appear
to actually do what it says. The sleeping tasks can be scattered to any
number of cpus as decided by select_fallback_rq().

Furthermore there should be absolutely no impact on load calculation
what so ever. nr_uninterruptible is only ever useful as a sum over all
cpus, this total sum doesn't change regardless of where you put the
value.

Worse, there's absolutely no relation to the tasks on the runqueue
(sleeping or otherwise) and nr_uninterruptible, so coupling these
actions makes no sense what so ever.

