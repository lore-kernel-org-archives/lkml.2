Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab2FKRUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 13:20:36 -0400
Received: from nat.nue.novell.com ([195.135.221.2]:61021 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab2FKRUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 13:20:18 -0400
Message-ID: <1339435214.7358.43.camel@marge.simpson.net>
Subject: Re: rcu: endless stalls
From: Mike Galbraith <mgalbraith@novell.com>
To: paulmck@linux.vnet.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <mszeredi@suse.cz>
Date: Mon, 11 Jun 2012 19:20:14 +0200
In-Reply-To: <1339424543.7350.101.camel@marge.simpson.net>
References: <1339409176.7350.26.camel@marge.simpson.net>
	 <20120611133953.GI2425@linux.vnet.ibm.com>
	 <1339424543.7350.101.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-11 at 16:22 +0200, Mike Galbraith wrote: 
> On Mon, 2012-06-11 at 06:39 -0700, Paul E. McKenney wrote: 
> > On Mon, Jun 11, 2012 at 12:06:16PM +0200, Mike Galbraith wrote:
> > > Greetings,
> > > 
> > > I received a report of a 48 core UV box hitting a gripe, taking longer
> > > than timeout to emit same, so box griped endlessly, forcing reboot.
> > 
> > So it took minutes to print an RCU CPU stall warning?  On only 48 CPUs?
> > 
> > If so, yow!!!
> 
> The report was a tad fuzzy on details, but serial console can take a
> while at low baud rate, and the box was apparently perma-stalled.

Gee, no wonder it took a while to emit the gripe, there were a few more
than 48 CPUs actually.. 4048 more to be precise.

4096 tasks on 4096 CPUs all hammering wait_lock at once r!pretty.

2aa15890 - mm: prevent concurrent unmap_mapping_range() on the same inode

-Mike

