Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab0EGRwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 13:52:33 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57874 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756292Ab0EGRwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 13:52:30 -0400
Date: Fri, 7 May 2010 18:51:59 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Tony Lindgren <tony@atomide.com>, Brian Swetland <swetland@google.com>,
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
Message-ID: <20100507175159.GB23952@srcf.ucam.org>
References: <20100506170151.GA30928@atomide.com> <20100506170956.GA28104@srcf.ucam.org> <20100506171453.GC30928@atomide.com> <1273167311.20494.13.camel@c-dwalke-linux.qualcomm.com> <20100506183605.GF30928@atomide.com> <1273173110.20494.19.camel@c-dwalke-linux.qualcomm.com> <20100507020057.GG30928@atomide.com> <1273252837.3542.30.camel@c-dwalke-linux.qualcomm.com> <20100507173621.GA23604@srcf.ucam.org> <1273254043.3542.37.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273254043.3542.37.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 10:40:43AM -0700, Daniel Walker wrote:
> On Fri, 2010-05-07 at 18:36 +0100, Matthew Garrett wrote:
> > If your wakeup latencies are sufficiently low and you have fine-grained 
> > enough control over your hardware then suspend in idle is a reasonable 
> > thing to do - but if you have a userspace app that's spinning then 
> > that doesn't solve the issue.
> 
> If there's a userspace app spinning then you don't go idle (or that's my
> assumption anyway). You mean like repeatedly blocking and unblocking
> right?

Right, that's the problem. idle-based suspend works fine if your 
applications let the system go idle, but if your applications are 
anything other than absolutely perfect in this respect then you consume 
significant power even if the device is sitting unused in someone's 
pocket.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
