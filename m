Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab2HMWAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:00:43 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36743 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648Ab2HMWAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:00:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH][Alternative][RFC] PM / Runtime: Introduce driver runtime PM work routine
Date: Tue, 14 Aug 2012 00:06:37 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>, Ming Lei <tom.leiming@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <Pine.LNX.4.44L0.1208131737400.27622-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1208131737400.27622-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208140006.37977.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 13, 2012, Alan Stern wrote:
> On Mon, 13 Aug 2012, Rafael J. Wysocki wrote:
> 
> > > I guess the best we can say is that if you call pm_runtime_barrier()  
> > > after updating the dev_pm_ops method pointers then after the barrier
> > > returns, the old method pointers will not be invoked and the old method
> > > routines will not be running.  So we need an equivalent guarantee with
> > > regard to the pm_runtime_work pointer.  (Yes, we could use a better 
> > > name for that pointer.)
> > > 
> > > Which means the code in the patch isn't quite right, because it saves 
> > > the pm_runtime_work pointer before calling rpm_resume().  Maybe we 
> > > should avoid looking at the pointer until rpm_resume() returns.
> > 
> > Yes, we can do that.
> > 
> > Alternatively, we can set power.work_in_progress before calling
> > rpm_resume(dev, 0) (i.e. regard the resume as a part of the work) to make
> > the barrier wait for all of it to complete.
> 
> Yep, that would work.  In fact, I did it that way in the proposed code 
> posted earlier in this thread.  (But that was just on general 
> principles, not because I had this particular race in mind.)

OK

I need to prepare a new patch now, but first I'll send a couple of (minor)
fixes for the core runtime PM code.

Thanks,
Rafael
