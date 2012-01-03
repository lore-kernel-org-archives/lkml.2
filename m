Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab2ACVjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 16:39:08 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:48454 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab2ACVjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 16:39:06 -0500
Date: Tue, 3 Jan 2012 13:38:30 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: INFO: task rcuc/0:7 blocked for more than 120 seconds.
Message-ID: <20120103213830.GG2376@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1324901803.31721.4.camel@lappy>
 <20111226163148.GC2435@linux.vnet.ibm.com>
 <1324977203.28904.1.camel@lappy>
 <20111228042959.GA2477@linux.vnet.ibm.com>
 <20120103202716.GA8384@linux.vnet.ibm.com>
 <20120103203717.GA6701@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120103203717.GA6701@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12010321-6148-0000-0000-0000026097CB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 03, 2012 at 12:37:17PM -0800, Greg KH wrote:
> On Tue, Jan 03, 2012 at 12:27:16PM -0800, Paul E. McKenney wrote:
> > On Tue, Dec 27, 2011 at 08:29:59PM -0800, Paul E. McKenney wrote:
> > > On Tue, Dec 27, 2011 at 11:13:23AM +0200, Sasha Levin wrote:
> > > > On Mon, 2011-12-26 at 08:31 -0800, Paul E. McKenney wrote:
> > > > > Except that when I try looking for task_notify_func() in current mainline,
> > > > > I get nothing.
> > > > > 
> > > > > Where is task_notify_func() coming from? 
> > > > 
> > > > I was testing linux-next, it actually comes from the android tree:
> > > > drivers/staging/android/lowmemorykiller.c
> > > 
> > > That does sound familiar...  I wonder if the stuff in staging is current
> > > Android or historical stuff.
> > 
> > And memory did serve for once.  ;-)
> > 
> > Current Android has the following for task_notify_func():
> > 
> > static int
> > task_notify_func(struct notifier_block *self, unsigned long val, void *data)
> > {
> > 	struct task_struct *task = data;
> > 
> > 	if (task == lowmem_deathpending)
> > 		lowmem_deathpending = NULL;
> > 
> > 	return NOTIFY_OK;
> > }
> > 
> > This is from https://android.googlesource.com/kernel/common.git.
> > 
> > Commit 5545554aac04918ece318270d63cbfcb015577a9 fixed this problem.
> > The commit is shown below, FYI.
> > 
> > Greg, would it be possible to pull in the current Android code?  There
> > have been a few fixes.  ;-)
> 
> I did base the stuff in staging on the common.git tree, but for some
> reason this patch wasn't applied, odd, I'll go apply it now...
> 
> Ah, I see, it didn't apply for various reasons:
> 
> patching file drivers/staging/android/lowmemorykiller.c
> Hunk #1 FAILED at 71.
> Hunk #2 FAILED at 168.
> Hunk #3 succeeded at 196 (offset 11 lines).
> Hunk #4 succeeded at 204 (offset 11 lines).
> 
> Care to rebase this patch and send it to me so that I can apply it?  I
> don't have the time to do it myself at the moment, sorry, lots of higher
> priority items to get done this week, sorry.

I will give it a shot.  Working with linux-next -- if some other tree
would be better for you, please let me know.

							Thanx, Paul

