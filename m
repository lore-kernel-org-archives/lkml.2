Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab1BWLDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 06:03:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:44711 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab1BWLDW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 06:03:22 -0500
Subject: Re: [PATCH 2/2] sched: allow users with rtprio rlimit to change
 from SCHED_IDLE policy
From: Peter Zijlstra <peterz@infradead.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, richard.purdie@linuxfoundation.org
In-Reply-To: <1298408674-3130-3-git-send-email-dvhart@linux.intel.com>
References: <1298408674-3130-1-git-send-email-dvhart@linux.intel.com>
	 <1298408674-3130-3-git-send-email-dvhart@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 23 Feb 2011 12:03:09 +0100
Message-ID: <1298458989.2217.361.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-22 at 13:04 -0800, Darren Hart wrote:
> As it stands, users with rtprio rlimit permissions can change their policy from
> SCHED_OTHER to SCHED_FIFO and back. They can change to SCHED_IDLE, but not back
> to SCHED_FIFO. If they have the rtprio permission, they should be able to. Once
> in SCHED_FIFO, they could go back to SCHED_OTHER. This patch allows users with
> rtprio permission to change out of SCHED_IDLE.
> 

Ingo, can you remember the rationale for this?

The fact is that SCHED_IDLE is very near nice-20, and we can do:

peterz@twins:~$ renice 5 -p $$
1867: old priority 0, new priority 5
peterz@twins:~$ renice 0 -p $$
1867: old priority 5, new priority 0

Which would suggest that we should be able to return to SCHED_OTHER
RLIMIT_NICE-20.

Hmm?

