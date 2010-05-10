Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab0EJUY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 16:24:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37946 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756630Ab0EJUYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 16:24:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Date: Mon, 10 May 2010 22:25:52 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Brian Swetland <swetland@google.com>
References: <1272667021-21312-1-git-send-email-arve@android.com> <87wrvl5479.fsf@deeprootsystems.com> <87632vhbs8.fsf@deeprootsystems.com>
In-Reply-To: <87632vhbs8.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005102225.52431.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 May 2010, Kevin Hilman wrote:
> Hello,

Hi Kevin,

> I think many folks are still confused about exactly the problem being
> solved by this series as well as mixed up between opportunistic
> suspend and suspend blockers.  Also, how this series impatcs the rest
> of the kernel (especially PM-aware drivers and subsystems) has caused
> a bit of confusion.
> 
> To help with the confusion, I think a much clearer description of the
> problem being solved and the proposed solution is needed.  
> 
> To that end, I created a starting point for that below which
> summarizes how I understand the problem and the proposed solution, but
> of course this should be filled out in more detail and updated as part
> of the documentation that goes with this series.
> 
> Hope this helps improve the understanding of this feature,

Yes, I think this is helpful.

> Table of Contents
> =================
> 1 Problem Statement 
> 2 Solution: Opportunistic suspend 
>     2.1 When to use a suspend blocker 
>     2.2 Usage in PM aware drivers 
> 
> 
> 1 Problem Statement 
> ~~~~~~~~~~~~~~~~~~~~
> 
> Want to to hit deep power state, even when the system is not actually
> idle.
> 
> Why?
> 
> - some hardware is not capable of deep power states in idle
> - difficulty getting userspace and/or kernel to be idle
> 
> 2 Solution: Opportunistic suspend 
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Create an additional "idle path" which has new rules for determining
> idleness.  When this new "idle" is reached, trigger full-system
> suspend.  Since a suspend is triggered whenever the opportunity
> arises, this is called opportunistic suspend.
> 
> The new rules for making the idleness decision are simple:
> 
> 1.  system may suspend if and only if no suspend blockers are held
> 
> 2.1 When to use a suspend blocker 
> ==================================
> 
> [A list of reasons why suspend blockers might be used would be very
>  helpful here.] 
> 
> - ensure wakeup events propagate to userspace (e.g. keypad example in doc)
> 
> - screen is on
> 
> - someone mentioned "Google use cases"
>   (would be nice to hear about more of these)

Yes, I think the Android developers know quite a few cases where suspend
blockers are useful.

> 2.2 Usage in PM aware drivers 
> ==============================
> 
> [An example of how a driver already using runtime PM would use 
>  a suspend blocker would also be helpful.

When we have any drivers using both in the tree, they will be used as examples
here.

Thanks,
Rafael
