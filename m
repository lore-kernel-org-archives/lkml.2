Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742Ab0EGVth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 17:49:37 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54618 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758684Ab0EGVt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 17:49:26 -0400
Date: Fri, 7 May 2010 22:48:55 +0100
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
Message-ID: <20100507214855.GA30190@srcf.ucam.org>
References: <1273259186.3542.93.camel@c-dwalke-linux.qualcomm.com> <20100507192837.GM387@atomide.com> <20100507193353.GA27175@srcf.ucam.org> <20100507195548.GN387@atomide.com> <20100507202859.GA27328@srcf.ucam.org> <20100507205329.GP387@atomide.com> <20100507210304.GA28701@srcf.ucam.org> <20100507212556.GQ387@atomide.com> <20100507213917.GE28906@srcf.ucam.org> <20100507214211.GR387@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100507214211.GR387@atomide.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 02:42:11PM -0700, Tony Lindgren wrote:
> * Matthew Garrett <mjg@redhat.com> [100507 14:34]:
> > How do you know to wake the process up in response to the keypress?
> 
> Does it matter for processes that are not "certified"? Maybe you
> could assume that you can keep it stopped until the screen is on
> again, or some other policy.

Yes, it matters. You don't necessarily know whether to turn the screen 
on until the app has had an opportunity to process the event. This is 
exactly the kind of use case that suspend blocks are intended to allow, 
so alternatives that don't permit that kind of use case aren't really 
adequate alternatives.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
