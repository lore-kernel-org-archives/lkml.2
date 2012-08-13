Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab2HMVja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 17:39:30 -0400
Received: from netrider.rowland.org ([192.131.102.5]:41282 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753014Ab2HMVj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 17:39:28 -0400
Date: Mon, 13 Aug 2012 17:39:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux PM list <linux-pm@vger.kernel.org>, Ming Lei <tom.leiming@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH][Alternative][RFC] PM / Runtime: Introduce driver runtime
 PM work routine
In-Reply-To: <201208132156.48942.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1208131737400.27622-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2012, Rafael J. Wysocki wrote:

> > I guess the best we can say is that if you call pm_runtime_barrier()  
> > after updating the dev_pm_ops method pointers then after the barrier
> > returns, the old method pointers will not be invoked and the old method
> > routines will not be running.  So we need an equivalent guarantee with
> > regard to the pm_runtime_work pointer.  (Yes, we could use a better 
> > name for that pointer.)
> > 
> > Which means the code in the patch isn't quite right, because it saves 
> > the pm_runtime_work pointer before calling rpm_resume().  Maybe we 
> > should avoid looking at the pointer until rpm_resume() returns.
> 
> Yes, we can do that.
> 
> Alternatively, we can set power.work_in_progress before calling
> rpm_resume(dev, 0) (i.e. regard the resume as a part of the work) to make
> the barrier wait for all of it to complete.

Yep, that would work.  In fact, I did it that way in the proposed code 
posted earlier in this thread.  (But that was just on general 
principles, not because I had this particular race in mind.)

Alan Stern

