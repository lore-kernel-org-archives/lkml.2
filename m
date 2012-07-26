Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab2GZLCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 07:02:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:44186 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab2GZLCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 07:02:15 -0400
Date: Thu, 26 Jul 2012 13:02:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
cc: Alan Stern <stern@rowland.harvard.edu>, mingo@kernel.org,
        peterz@infradead.org, rusty@rustcorp.com.au,
        paulmck@linux.vnet.ibm.com, namhyung@kernel.org, tj@kernel.org,
        rjw@sisk.pl, nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC PATCH 0/6] CPU hotplug: Reverse invocation of notifiers
 during CPU hotplug
In-Reply-To: <50102424.5010301@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.02.1207261256030.32033@ionos>
References: <Pine.LNX.4.44L0.1207251054420.2008-100000@iolanthe.rowland.org> <50101733.4030205@linux.vnet.ibm.com> <alpine.LFD.2.02.1207251758340.32033@ionos> <50102424.5010301@linux.vnet.ibm.com>
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
> > While I thought about having a full dependency tracking system, I'm
> > quite convinced by now, that hotplug is a rather linear sequence which
> > does not provide much room for paralell setup/teardown.
> >
> 
> Pretty much, when considering hotplug of a single CPU.
> 
> (But when considering booting, Arjan had proposed (while discussing
> about his asynchronous booting patch) that it would be good to split
> up physical vs logical parts of the booting/hotplug, so that the
> physical part can happen in parallel with other CPUs, while the
> logical online can be done serially, much later. Anyway, this is
> slightly off-topic here, since we are mainly talking about hotplug
> of a single cpu here. I just thought of putting a word about that
> here, since we are discussing hotplug redesign anyways..)

Well, the nice thing about having a proper state machine is that you
can tell the code to advance the BP only to the "kick the other cpu"
step, which is before the first sync point, so you can leave the state
there and continue with "bring it fully online" later. 

So that feature comes basically for free. :)

Thanks,

	tglx
