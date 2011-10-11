Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283Ab1JKVyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 17:54:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34228 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab1JKVyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 17:54:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2/3] Mutually exclude cpu online and suspend/hibernate
Date: Tue, 11 Oct 2011 23:56:31 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc9+; KDE/4.6.0; x86_64; ; )
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, bp@amd64.org, pavel@ucw.cz,
        len.brown@intel.com, tj@kernel.org, mingo@elte.hu,
        akpm@linux-foundation.org, suresh.b.siddha@intel.com,
        lucas.demarchi@profusion.mobi, rusty@rustcorp.com.au,
        rdunlap@xenotime.net, vatsa@linux.vnet.ibm.com, ashok.raj@intel.com,
        tigran@aivazian.fsnet.co.uk, tglx@linutronix.de, hpa@zytor.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20111010123102.15067.23128.stgit@srivatsabhat.in.ibm.com> <4E930C53.3010309@linux.vnet.ibm.com> <4E94A7F8.9010309@linux.vnet.ibm.com>
In-Reply-To: <4E94A7F8.9010309@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110112356.31502.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 11, 2011, Srivatsa S. Bhat wrote:
> On 10/10/2011 08:46 PM, Srivatsa S. Bhat wrote:
> > On 10/10/2011 07:56 PM, Peter Zijlstra wrote:
> >> On Mon, 2011-10-10 at 18:15 +0530, Srivatsa S. Bhat wrote:
> >>>> +     /*
> >>>> +      * Prevent cpu online and suspend/hibernate (including freezer)
> >>>> +      * operations from running in parallel. Fail cpu online if suspend or
> >>>> +      * hibernate has already started.
> >>>> +      */
> >>>> +     if (!trylock_pm_sleep())
> >>>
> >>> Would it be better to hook into the suspend/hibernate notifiers and
> >>> use them to exclude cpu hotplug from suspend/hibernate, instead of
> >>> trying to take pm_mutex lock like this?
> >>> Peter, I remember you pointing out in another patch's review
> >>> (http://thread.gmane.org/gmane.linux.kernel/1198312/focus=1199087)
> >>> that introducing more locks in cpu hotplug would be a bad idea. Does that
> >>> comment hold here as well, or is this fine? 
> >>
> >> Arguably pm_mutex is already involved in the whole hotplug dance due to
> >> suspend using it, that said, I'm not at all familiar with the whole
> >> suspend/hibernate side of things.
> >>
> >> I tried having a quick look this morning but failed to find the actual
> >> code.
> >>
> >> I think it would be good to have an overview of the various locks and a
> >> small description of how they interact/nest.
> >>
> > 
> > Sure. I'll put together whatever I have understood, in the form of a patch
> > to Documentation/power directory and post it tomorrow, for the benefit of
> > all.
> > 
> 
> Here it is, just as promised :-)
> http://lkml.org/lkml/2011/10/11/393

Well, I have an idea.

Why don't we make drivers/base/cpu.c:store_online() take pm_mutex
in addition to calling cpu_hotplug_driver_lock()?  This at least
will make the interface mutually exclusive with suspend/hibernation.

Thanks,
Rafael
