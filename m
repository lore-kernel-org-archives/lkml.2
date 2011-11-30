Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758Ab1K3Lsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 06:48:51 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34888 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab1K3Lst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 06:48:49 -0500
Date: Wed, 30 Nov 2011 06:48:41 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, sfr@canb.auug.org.au,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (akpm
 tree related)
Message-ID: <20111130114841.GB5677@hmsreliant.think-freely.org>
References: <20111130155226.b571cfd7887f03f9e8e1285b@canb.auug.org.au>
 <20111130.004010.1075431174091251814.davem@davemloft.net>
 <20111129220728.b3351335.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111129220728.b3351335.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.6 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 10:07:28PM -0800, Andrew Morton wrote:
> On Wed, 30 Nov 2011 00:40:10 -0500 (EST) David Miller <davem@davemloft.net> wrote:
> 
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date: Wed, 30 Nov 2011 15:52:26 +1100
> > 
> > > And many more similar.
> > > 
> > > Caused (or exposed) by commit 9222aa56c0ce
> > > ("include/net/netprio_cgroup.h: various fixes") from the akpm tree.
> > > 
> > > I have reverted that commit for today.
> > 
> > Andrew, please submit networking bug fixes to the networking maintainers
> > in order to avoid problems like this in the future.
> > 
> > Unlike other subsystems, I guarentee to handle it within 24 hours, often
> > much faster.
> > 
> 
> This is my attempt to address the issues I mentioned last week.  It is
> still under development and doesn't work yet.  I thought it did.
> 
> I'm now trying to get my brain around what that code is doing with
> Kconfig symbols and net_prio_subsys_id.  I'm suspecting it's all to
> make cgroup-subsys-within-a-module appear to work.
> 
> afaict net_prio_subsys_id is an enum if CONFIG_NETPRIO_CGROUP=y and is
> an `extern int' when CONFIG_NETPRIO_CGROUP=m.  It's unclear to me why
> the extern int version or net_prio_subsys_id exists at all, really.
> 
> 
I implemented this code the same way that the net_cls cgroup does.  I'm not at
all sure whats going on in your tree, as its building as both a module and
monolitically in net-next.  I'll get it sorted today though.
Neil

