Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab0JKSsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 14:48:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:49488 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab0JKSsj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 14:48:39 -0400
Subject: Re: [RESEND PATCH 1/2] IRQ: use cpu_possible_mask rather than
 online_mask in setup_affinity
From: Peter Zijlstra <peterz@infradead.org>
To: Sonny Rao <sonnyrao@us.ibm.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>, miltonm@bga.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ian Campbell <ian.campbell@citrix.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        linux-kernel@vger.kernel.org, sonnyrao@linux.vnet.ibm.com
In-Reply-To: <20101006210236.GQ13726@us.ibm.com>
References: <1285968378-12805-1-git-send-email-nacc@us.ibm.com>
	 <1285968378-12805-2-git-send-email-nacc@us.ibm.com>
	 <1286017262.2144.90.camel@laptop>  <20101006210236.GQ13726@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 11 Oct 2010 20:48:25 +0200
Message-ID: <1286822905.1998.96.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-06 at 16:02 -0500, Sonny Rao wrote:
> > > With user-driven dynamic SMT,
> > 
> > What's that?
> 
> Well, that is basically a feature where we can use CPU hotplug to
> force a particular mode on an SMT (hardware multithreaded) processor 
> 
> The point here was really that on such multi-threaded processors -- which are
> becoming more common -- cpu hotplug can potentially be used fairly
> often. 

I guess you're talking about the trainwreck called power7? Where you
want to force the thing into SMT1/2 mode instead of letting it degrade
into SMT4 mode?

Why would you want to change that often? Do realize that cpu-hotplug is
a very heavy, very expensive operation, doing it more than a few times
an hour counts as excessive in my book.

For RT I've been thinking of extending cpusets with a feature that
allows you to disable things like SMT and MC on a set, ensuring you get
no pipeline/cache interference.

But this is something you setup once and then run your workload, its not
something you'll change often (in fact, hotplugging cpus will utterly
wreck your RT workload).

Also, I don't see why you would want to have interrupts with affinity to
offline cpus only, that sounds plain wrong, an offline'd cpu is not able
to deal with interrupts.

I wish people would stop abusing hotplug as:
  - resource management
  - power management
  - other crazy ass things

Its not suitable for those..
