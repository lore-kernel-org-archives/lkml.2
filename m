Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477Ab0EEVMF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 17:12:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40925 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754787Ab0EEVMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 17:12:03 -0400
Date: Wed, 5 May 2010 17:12:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: mark gross <mgross@linux.intel.com>
cc: markgross@thegnar.org, Len Brown <len.brown@intel.com>,
       <linux-doc@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 1/8] PM: Add suspend block api.
In-Reply-To: <20100505202826.GB7450@linux.intel.com>
Message-ID: <Pine.LNX.4.44L0.1005051705200.1885-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 May 2010, mark gross wrote:

> > > True, you need an ack back from user mode for when its ok to allow
> > > suspend to happen.  This ack is device specific and needs to be custom
> > > built per product to its wake up sources.
> > 
> > No and no.  Nothing special is needed.  All userspace needs to do is 
> > remove the condition that led to the blocker being enabled initially -- 
> > which is exactly what userspace would do normally anyway.
> 
> Oh, like tell the modem that user mode has handled the ring event and
> its ok to un-block?

No, that's not how it works.  It would go like this:

	The modem IRQ handler queues its event to the input subsystem.  
	As it does so the input subsystem enables a suspend blocker, 
	causing the system to stay awake after the IRQ is done.

	The user program enables its own suspend blocker before reading
	the input queue.  When the queue is empty, the input subsystem
	releases its suspend blocker.

	When the user program finishes processing the event, it
	releases its suspend blocker.  Now the system can go back to
	sleep.

At no point does the user program have to communicate anything to the 
modem driver, and at no point does it have to do anything out of the 
ordinary except to enable and disable a suspend blocker.

Alan Stern

