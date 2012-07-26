Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab2GZK4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 06:56:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:44155 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab2GZK4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 06:56:06 -0400
Date: Thu, 26 Jul 2012 12:55:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
cc: Alan Stern <stern@rowland.harvard.edu>, mingo@kernel.org,
        peterz@infradead.org, rusty@rustcorp.com.au,
        paulmck@linux.vnet.ibm.com, namhyung@kernel.org, tj@kernel.org,
        rjw@sisk.pl, nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] CPU hotplug: Reverse invocation of notifiers
 during CPU hotplug
In-Reply-To: <50103955.9020301@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.02.1207261248130.32033@ionos>
References: <Pine.LNX.4.44L0.1207251054420.2008-100000@iolanthe.rowland.org> <50101733.4030205@linux.vnet.ibm.com> <alpine.LFD.2.02.1207251758340.32033@ionos> <50103955.9020301@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2012, Srivatsa S. Bhat wrote:
> On 07/25/2012 10:00 PM, Thomas Gleixner wrote:
> > struct hotplug_event hotplug_events_bp[CPU_HOTPLUG_MAX_EVENTS];
> > struct hotplug_event hotplug_events_ap[CPU_HOTPLUG_MAX_EVENTS];
> >    
> > The _bp one is the list of events which are executed on the active cpu
> > and the _ap ones are those executed on the hotplugged cpu.
> > 
> > The core code advances the events in sync steps, so both BP and AP can
> > issue a stop on the process and cause a rollback.
> 
> What exactly does "sync steps" mean in this context? Also, for the CPU

Sync step means, that both sides need to synchronize - not at every
step, but at well defined synchronization points. You can't advance
the AP to online state unless the BP has done the preparatory stuff
already.

> offline event, the event could start off with both the BP and the AP being
> the same CPU.. Does this design take care of that case?

Once the AP leaves the state where tasks can be freely scheduled on
it, the take down thread migrates automagically. And that's one of the
first things I'm trying to do so the first synchronization point is
after that.

Thanks,

	tglx
