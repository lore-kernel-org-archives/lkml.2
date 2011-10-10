Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab1JJOU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 10:20:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:56371 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104Ab1JJOU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 10:20:28 -0400
Subject: Re: [PATCH v2 2/3] Mutually exclude cpu online and
 suspend/hibernate
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, bp@amd64.org, pavel@ucw.cz, len.brown@intel.com,
        tj@kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
        suresh.b.siddha@intel.com, lucas.demarchi@profusion.mobi,
        rusty@rustcorp.com.au, rdunlap@xenotime.net, vatsa@linux.vnet.ibm.com,
        ashok.raj@intel.com, tigran@aivazian.fsnet.co.uk, tglx@linutronix.de,
        hpa@zytor.com, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
In-Reply-To: <4E92E8E0.4090004@linux.vnet.ibm.com>
References: <20111010123102.15067.23128.stgit@srivatsabhat.in.ibm.com>
	 <20111010123242.15067.48238.stgit@srivatsabhat.in.ibm.com>
	 <4E92E8E0.4090004@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Oct 2011 16:26:28 +0200
Message-ID: <1318256788.14400.53.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-10 at 18:15 +0530, Srivatsa S. Bhat wrote:
> > +     /*
> > +      * Prevent cpu online and suspend/hibernate (including freezer)
> > +      * operations from running in parallel. Fail cpu online if suspend or
> > +      * hibernate has already started.
> > +      */
> > +     if (!trylock_pm_sleep())
> 
> Would it be better to hook into the suspend/hibernate notifiers and
> use them to exclude cpu hotplug from suspend/hibernate, instead of
> trying to take pm_mutex lock like this?
> Peter, I remember you pointing out in another patch's review
> (http://thread.gmane.org/gmane.linux.kernel/1198312/focus=1199087)
> that introducing more locks in cpu hotplug would be a bad idea. Does that
> comment hold here as well, or is this fine? 

Arguably pm_mutex is already involved in the whole hotplug dance due to
suspend using it, that said, I'm not at all familiar with the whole
suspend/hibernate side of things.

I tried having a quick look this morning but failed to find the actual
code.

I think it would be good to have an overview of the various locks and a
small description of how they interact/nest.

I just remember being very surprised about finding out the hotplug usage
of suspend/hibernate wasn't at all serialized against the regular
hotplug thingies.. (see 144060fee07e9c22e179d00819c83c86fbcbf82c).



