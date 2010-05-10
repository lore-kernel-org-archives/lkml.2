Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab0EJSG0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 14:06:26 -0400
Received: from mail-qy0-f183.google.com ([209.85.221.183]:64467 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969Ab0EJSGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 14:06:23 -0400
To: Arve =?iso-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
References: <1272667021-21312-1-git-send-email-arve@android.com>
	<87wrvl5479.fsf@deeprootsystems.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Mon, 10 May 2010 11:06:15 -0700
In-Reply-To: <87wrvl5479.fsf@deeprootsystems.com> (Kevin Hilman's message of "Mon\, 03 May 2010 09\:40\:26 -0700")
Message-ID: <87632vhbs8.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I think many folks are still confused about exactly the problem being
solved by this series as well as mixed up between opportunistic
suspend and suspend blockers.  Also, how this series impatcs the rest
of the kernel (especially PM-aware drivers and subsystems) has caused
a bit of confusion.

To help with the confusion, I think a much clearer description of the
problem being solved and the proposed solution is needed.  

To that end, I created a starting point for that below which
summarizes how I understand the problem and the proposed solution, but
of course this should be filled out in more detail and updated as part
of the documentation that goes with this series.

Hope this helps improve the understanding of this feature,

Kevin



Table of Contents
=================
1 Problem Statement 
2 Solution: Opportunistic suspend 
    2.1 When to use a suspend blocker 
    2.2 Usage in PM aware drivers 


1 Problem Statement 
~~~~~~~~~~~~~~~~~~~~

Want to to hit deep power state, even when the system is not actually
idle.

Why?

- some hardware is not capable of deep power states in idle
- difficulty getting userspace and/or kernel to be idle

2 Solution: Opportunistic suspend 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Create an additional "idle path" which has new rules for determining
idleness.  When this new "idle" is reached, trigger full-system
suspend.  Since a suspend is triggered whenever the opportunity
arises, this is called opportunistic suspend.

The new rules for making the idleness decision are simple:

1.  system may suspend if and only if no suspend blockers are held

2.1 When to use a suspend blocker 
==================================

[A list of reasons why suspend blockers might be used would be very
 helpful here.] 

- ensure wakeup events propagate to userspace (e.g. keypad example in doc)

- screen is on

- someone mentioned "Google use cases"
  (would be nice to hear about more of these)

2.2 Usage in PM aware drivers 
==============================

[An example of how a driver already using runtime PM would use 
 a suspend blocker would also be helpful.

