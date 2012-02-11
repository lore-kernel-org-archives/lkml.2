Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab2BKVcd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 16:32:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48029 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592Ab2BKVcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 16:32:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] PM / Sleep: Remove unnecessary label from suspend_freeze_processes()
Date: Sat, 11 Feb 2012 22:36:20 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <201202110035.32993.rjw@sisk.pl> <4F35EC3C.5090305@linux.vnet.ibm.com>
In-Reply-To: <4F35EC3C.5090305@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201202112236.20760.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, February 11, 2012, Srivatsa S. Bhat wrote:
> On 02/11/2012 05:05 AM, Rafael J. Wysocki wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > The Finish label in suspend_freeze_processes() is in fact necessary
> 
> 
> s/necessary/unnecessary
> 
> > and makes the function look more complicated that it really is, so
> 
> 
> s/that/than
> 
> > remove it (along with a few empty lines).
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> > 
> 
> 
> Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Well, thanks for the fixes!

Rafael


> > The patch is on top of linux-pm/pm-sleep.
> > 
> > Thanks,
> > Rafael
> > 
> > ---
> >  kernel/power/power.h |    5 +----
> >  1 file changed, 1 insertion(+), 4 deletions(-)
> > 
> > Index: linux/kernel/power/power.h
> > ===================================================================
> > --- linux.orig/kernel/power/power.h
> > +++ linux/kernel/power/power.h
> > @@ -234,16 +234,14 @@ static inline int suspend_freeze_process
> >  	int error;
> > 
> >  	error = freeze_processes();
> > -
> >  	/*
> >  	 * freeze_processes() automatically thaws every task if freezing
> >  	 * fails. So we need not do anything extra upon error.
> >  	 */
> >  	if (error)
> > -		goto Finish;
> > +		return error;
> > 
> >  	error = freeze_kernel_threads();
> > -
> >  	/*
> >  	 * freeze_kernel_threads() thaws only kernel threads upon freezing
> >  	 * failure. So we have to thaw the userspace tasks ourselves.
> > @@ -251,7 +249,6 @@ static inline int suspend_freeze_process
> >  	if (error)
> >  		thaw_processes();
> > 
> > - Finish:
> >  	return error;
> >  }
> > 
> > 
> 
> 
> 

