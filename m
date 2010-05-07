Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107Ab0EGSqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 14:46:52 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50934 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab0EGSqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 14:46:50 -0400
Date: Fri, 7 May 2010 19:46:21 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Brian Swetland <swetland@google.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       mark gross <mgross@linux.intel.com>, markgross@thegnar.org,
       Len Brown <len.brown@intel.com>, linux-doc@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 1/8] PM: Add suspend block api.
Message-ID: <20100507184621.GA25978@srcf.ucam.org>
References: <20100506174331.GA29103@srcf.ucam.org> <20100506183335.GE30928@atomide.com> <20100506184418.GA30669@srcf.ucam.org> <20100507020541.GH30928@atomide.com> <20100507171218.GA23142@srcf.ucam.org> <20100507173549.GF387@atomide.com> <20100507175025.GA23952@srcf.ucam.org> <20100507180152.GH387@atomide.com> <20100507182824.GA25198@srcf.ucam.org> <20100507184333.GL387@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100507184333.GL387@atomide.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 11:43:33AM -0700, Tony Lindgren wrote:
> * Matthew Garrett <mjg@redhat.com> [100507 11:23]:
> > On Fri, May 07, 2010 at 11:01:52AM -0700, Tony Lindgren wrote:
> > > * Matthew Garrett <mjg@redhat.com> [100507 10:46]:
> > > > Effective power management in the face of real-world applications is a 
> > > > reasonable usecase.
> > > 
> > > Sure there's no easy solution to misbehaving apps.
> > 
> > That's the point of the suspend blockers.
> 
> To me it sounds like suspending the whole system to deal with
> some misbehaving apps is an overkill. Sounds like kill -STOP
> the misbehaving apps should do the trick?

Freezer cgroups would work better, but it doesn't really change the 
point - if that application has an open network socket, how do you know 
to resume that application when a packet comes in?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
