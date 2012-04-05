Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab2DEMiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 08:38:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692Ab2DEMiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 08:38:04 -0400
Date: Thu, 5 Apr 2012 08:37:59 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@fedoraproject.org,
        pascal.chapperon@wanadoo.fr
Subject: Re: RCU related performance regression in 3.3
Message-ID: <20120405123759.GE1963@zod.bos.redhat.com>
References: <20120404152726.GB16299@zod.bos.redhat.com>
 <20120404213633.GI2302@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120404213633.GI2302@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2012 at 02:36:33PM -0700, Paul E. McKenney wrote:
> On Wed, Apr 04, 2012 at 11:27:27AM -0400, Josh Boyer wrote:
> > Hi Paul,
> > 
> > We've had a few reports of some boot slowdowns with the 3.3 rebase we
> > did in Fedora 16.  One of our users volunteered to bisect a vanilla
> > kernel and wound up at "rcu: Permit dyntick-idle with callbacks pending
> > (commit 7cb924990)".  You can find more details in the bug [1], but it's
> > been reported on both physical hardware and in virtual machines.
> > 
> > Have you seen anything like this in your testing?  Given the user used a
> > vanilla 3.3 kernel, I'm wondering if there is a targetted fix that might
> > be backported.  If so, it would be good to get that headed to the 3.3.y
> > stable tree.
> > 
> > josh
> > 
> > [1] https://bugzilla.redhat.com/show_bug.cgi?id=806548
> 
> I will look into this.  In the meantime, does setting
> CONFIG_RCU_FAST_NO_HZ=n get rid of the slowdowns?

Seems so.  Pascal tried 3.4-rc1 with and without that set and found that
disabling it lead to consistent timings.  He put his findings in the
bug, and I've also now CC'd him.

josh
