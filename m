Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab0EGVDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 17:03:37 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:47175 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748Ab0EGVDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 17:03:35 -0400
Date: Fri, 7 May 2010 22:03:04 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Daniel Walker <dwalker@fifo99.com>, Brian Swetland <swetland@google.com>,
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
Message-ID: <20100507210304.GA28701@srcf.ucam.org>
References: <20100507180152.GH387@atomide.com> <20100507182824.GA25198@srcf.ucam.org> <20100507184333.GL387@atomide.com> <20100507184621.GA25978@srcf.ucam.org> <1273259186.3542.93.camel@c-dwalke-linux.qualcomm.com> <20100507192837.GM387@atomide.com> <20100507193353.GA27175@srcf.ucam.org> <20100507195548.GN387@atomide.com> <20100507202859.GA27328@srcf.ucam.org> <20100507205329.GP387@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100507205329.GP387@atomide.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 01:53:29PM -0700, Tony Lindgren wrote:

> So for example, if I leave ping running in a a terminal, do you
> have some way of preventing that from eating the battery?

It depends on policy. If all network packets generate wakeup events then 
no, that will carry on eating battery. If ICMP doesn't generate a wakeup 
event then the process won't be run.

> Do you just suspend the whole system anyways at some point,
> or do you have some other trick?

If nothing's holding any suspend blocks then the system will enter 
suspend. If the packet generates a wakeup then the kernel would block 
suspend until userspace has had the opportunity to do so. Once userspace 
has handled the packet then it could release the block and the system 
will immediately transition back into suspend.

Here's a different example. A process is waiting for a keypress, but 
because it's badly written it's also drawing to the screen at 60 frames 
per second and preventing the system from every going to idle. How do 
you quiesce the system while still ensuring that the keypress will be 
delivered to the application?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
