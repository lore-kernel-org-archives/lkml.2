Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261Ab0EDOAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 10:00:06 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54237 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932198Ab0EDOAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 10:00:01 -0400
Date: Tue, 4 May 2010 09:59:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: markgross@thegnar.org
cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Len Brown <len.brown@intel.com>, <linux-doc@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Magnus Damm <damm@igel.co.jp>,
       <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 1/8] PM: Add suspend block api.
In-Reply-To: <20100504051256.GC3043@thegnar.org>
Message-ID: <Pine.LNX.4.44L0.1005040953510.1729-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 May 2010, mark gross wrote:

> You know things would be so much easier if the policy was a one-shot
> styled thing.  i.e. when enabled it does what it does, but upon resume
> the policy must be re-enabled by user mode to get the opportunistic
> behavior.  That way we don't need to grab the suspend blocker from the
> wake up irq handler all the way up to user mode as the example below
> calls out.  I suppose doing this would put a burden on the user mode code
> to keep track of if it has no pending blockers registered after a wake
> up from the suspend.  but that seems nicer to me than sprinkling
> overlapping blocker critical sections from the mettle up to user mode.
> 
> Please consider making the policy a one shot API that needs to be
> re-enabled after resume by user mode.  That would remove my issue with
> the design.

This won't work right if a second IRQ arrives while the first is being
processed.  Suppose the kernel driver for the second IRQ doesn't
activate a suspend blocker, and suppose all the userspace handlers for
the first IRQ end (and the opportunistic policy is re-enabled) before
the userspace handler for the second IRQ can start.  Then the system
will go back to sleep before userspace can handle the second IRQ.

Alan Stern

