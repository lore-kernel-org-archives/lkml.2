Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab2DEOAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 10:00:41 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:46551 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab2DEOAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 10:00:34 -0400
Date: Thu, 5 Apr 2012 07:00:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Boyer <jwboyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@fedoraproject.org,
        pascal.chapperon@wanadoo.fr
Subject: Re: RCU related performance regression in 3.3
Message-ID: <20120405140006.GB27672@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120404152726.GB16299@zod.bos.redhat.com>
 <20120404213633.GI2302@linux.vnet.ibm.com>
 <20120405123759.GE1963@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120405123759.GE1963@zod.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12040514-7408-0000-0000-000003FE0085
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2012 at 08:37:59AM -0400, Josh Boyer wrote:
> On Wed, Apr 04, 2012 at 02:36:33PM -0700, Paul E. McKenney wrote:
> > On Wed, Apr 04, 2012 at 11:27:27AM -0400, Josh Boyer wrote:
> > > Hi Paul,
> > > 
> > > We've had a few reports of some boot slowdowns with the 3.3 rebase we
> > > did in Fedora 16.  One of our users volunteered to bisect a vanilla
> > > kernel and wound up at "rcu: Permit dyntick-idle with callbacks pending
> > > (commit 7cb924990)".  You can find more details in the bug [1], but it's
> > > been reported on both physical hardware and in virtual machines.
> > > 
> > > Have you seen anything like this in your testing?  Given the user used a
> > > vanilla 3.3 kernel, I'm wondering if there is a targetted fix that might
> > > be backported.  If so, it would be good to get that headed to the 3.3.y
> > > stable tree.
> > > 
> > > josh
> > > 
> > > [1] https://bugzilla.redhat.com/show_bug.cgi?id=806548
> > 
> > I will look into this.  In the meantime, does setting
> > CONFIG_RCU_FAST_NO_HZ=n get rid of the slowdowns?
> 
> Seems so.  Pascal tried 3.4-rc1 with and without that set and found that
> disabling it lead to consistent timings.  He put his findings in the
> bug, and I've also now CC'd him.

Thank you for the info!  Is the performance problem limited to boot time,
or are there performance problems when the system is up and running?

							Thanx, Paul

