Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583Ab2ATGMu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 01:12:50 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:59357 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab2ATGMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 01:12:48 -0500
Date: Thu, 19 Jan 2012 22:12:14 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Simon Glass <sjg@chromium.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org
Subject: Re: [PATCH 3/3] serial: 8250: Add a wakeup_capable module param
Message-ID: <20120120061214.GA2551@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1326826563-32215-1-git-send-email-sjg@chromium.org>
 <201201190102.58788.rjw@sisk.pl>
 <20120119013731.GK2431@linux.vnet.ibm.com>
 <201201200103.34296.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201201200103.34296.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12012006-1780-0000-0000-0000027B50A9
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000245; HX=3.00000181; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00106487; UDB=6.00026788; UTC=2012-01-20
 06:12:45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 01:03:34AM +0100, Rafael J. Wysocki wrote:
> On Thursday, January 19, 2012, Paul E. McKenney wrote:
> > On Thu, Jan 19, 2012 at 01:02:58AM +0100, Rafael J. Wysocki wrote:
> > > On Wednesday, January 18, 2012, Paul E. McKenney wrote:
> > > > On Wed, Jan 18, 2012 at 02:15:59PM -0800, Simon Glass wrote:
> [...] 
> > > Yes, you can, but then I'd say it's not necessary for user space to
> > > be able to carry that out in a tight loop.  So, it seems, alternatively,
> > > we could make that loop a bit less tight, e.g. by adding an arbitrary
> > > sleep to the user space interface for the "disable" case.
> > 
> > Good point, that would work just as well and be simpler.
> 
> Thanks for the confirmation! :-)
> 
> By the way, I wonder, would it help to add synchronize_rcu() to
> wakeup_source_add() too?  Then, even if device_wakeup_enable() and
> device_wakeup_disable() are executed in a tight loop for the same
> device, the list_add/list_del operations will always happen in
> different RCU cycles (or at least it seems so).

I cannot immediately see how adding a synchronize_rcu() to
wakeup_source_add() would help anything.  You only need to wait for a
grace period on removal, not (normally) on addition.  The single grace
period during removal will catch up all other asynchronous RCU grace
period requests on that CPU.

Or am I missing your point?

							Thanx, Paul

