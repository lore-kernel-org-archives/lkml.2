Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab0IIIzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 04:55:05 -0400
Received: from www.tglx.de ([62.245.132.106]:50579 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab0IIIzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 04:55:03 -0400
Date: Thu, 9 Sep 2010 10:54:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arthur Kepner <akepner@sgi.com>
cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: [RFC/PATCH] notify user-level IRQ balancer when kernel assigns
 IRQ affinity
In-Reply-To: <20100903210554.GO2464@sgi.com>
Message-ID: <alpine.LFD.2.00.1009091050370.2477@localhost6.localdomain6>
References: <20100903210554.GO2464@sgi.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Sep 2010, Arthur Kepner wrote:

It might be helpful to cc the maintainer of kernel/irq on patches
which affect that area.

> 
> We've run into situations where a CPU runs out of interrupt 
> vectors, because all the interrupts are getting the default 
> affinity (and the interrupt balancer hasn't yet run).
> 
> The following emits a netlink message whenever an interrupt 
> is given a default CPU affinity. A user-level IRQ balancer 
> can use those messages to decide if, and how to reassign 
> affinities. This should allow us to avoid running out of 
> vectors on any particular CPU (or at least make it far less 
> likely).

Errm. If the irq balancer has not been run, then why should some new
irq balancer be up and running at this time. In the worst case you
need to sort that out during boot _before_ you even hit userspace.

Further this adds just redundant information as user space is already
notified about a new device being setup via udev, so what's the point
of adding another notification mechanism.

Thanks,

	tglx
