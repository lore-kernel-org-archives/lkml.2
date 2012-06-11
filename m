Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab2FKOW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 10:22:29 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:30484 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081Ab2FKOW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 10:22:28 -0400
Message-ID: <1339424543.7350.101.camel@marge.simpson.net>
Subject: Re: rcu: endless stalls
From: Mike Galbraith <mgalbraith@novell.com>
To: paulmck@linux.vnet.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Mon, 11 Jun 2012 16:22:23 +0200
In-Reply-To: <20120611133953.GI2425@linux.vnet.ibm.com>
References: <1339409176.7350.26.camel@marge.simpson.net>
	 <20120611133953.GI2425@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-11 at 06:39 -0700, Paul E. McKenney wrote: 
> On Mon, Jun 11, 2012 at 12:06:16PM +0200, Mike Galbraith wrote:
> > Greetings,
> > 
> > I received a report of a 48 core UV box hitting a gripe, taking longer
> > than timeout to emit same, so box griped endlessly, forcing reboot.
> 
> So it took minutes to print an RCU CPU stall warning?  On only 48 CPUs?
> 
> If so, yow!!!

The report was a tad fuzzy on details, but serial console can take a
while at low baud rate, and the box was apparently perma-stalled.

> My guess is that rcu_cpu_stall_suppress must be manipulated atomically
> for this to work reliably, for example, using xchg().

Ah, thanks.

-Mike

