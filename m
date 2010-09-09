Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab0IIPzG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 11:55:06 -0400
Received: from relay3.sgi.com ([192.48.152.1]:58706 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751624Ab0IIPzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 11:55:04 -0400
Date: Thu, 9 Sep 2010 08:55:02 -0700
From: Arthur Kepner <akepner@sgi.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: [RFC/PATCH] notify user-level IRQ balancer when kernel assigns
	IRQ affinity
Message-ID: <20100909155502.GB17836@sgi.com>
References: <20100903210554.GO2464@sgi.com> <alpine.LFD.2.00.1009091050370.2477@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1009091050370.2477@localhost6.localdomain6>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 09, 2010 at 10:54:50AM +0200, Thomas Gleixner wrote:
> On Fri, 3 Sep 2010, Arthur Kepner wrote:
> 
> It might be helpful to cc the maintainer of kernel/irq on patches
> which affect that area.

It wasn't (and after revieweing the MAINTAINERS file, still isn't) 
clear to me that you're the maintainer there, but I'll cc you on 
this topic in the future.

> 
> > 
> > We've run into situations where a CPU runs out of interrupt 
> > vectors, because all the interrupts are getting the default 
> > affinity (and the interrupt balancer hasn't yet run).
> > 
> > The following emits a netlink message whenever an interrupt 
> > is given a default CPU affinity. A user-level IRQ balancer 
> > can use those messages to decide if, and how to reassign 
> > affinities. This should allow us to avoid running out of 
> > vectors on any particular CPU (or at least make it far less 
> > likely).
> 
> Errm. If the irq balancer has not been run, then why should some new
> irq balancer be up and running at this time. In the worst case you
> need to sort that out during boot _before_ you even hit userspace.

David M. made the same point.

I've got a new scheme in the works here:

http://marc.info/?l=linux-kernel&m=128381632020999&w=2

When I get some time on a big NUMA system, I'll test the latest 
iteration of that, and post an update.

-- 
Arthur
