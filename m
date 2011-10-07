Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab1JGT5v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 15:57:51 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51065 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab1JGT5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 15:57:50 -0400
Date: Fri, 7 Oct 2011 20:57:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Joe Perches <joe@perches.com>
Cc: =?iso-8859-1?Q?V=EDctor_Manuel_J=E1quez?= Leal 
	<vjaquez@igalia.com>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        Timo Teras <timo.teras@solidboot.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3] omap: dmtimer: convert printk to pr_err
Message-ID: <20111007195714.GB26805@n2100.arm.linux.org.uk>
References: <20111006201827.GT6324@atomide.com> <1317977417-17874-1-git-send-email-vjaquez@igalia.com> <20111007092243.GC27281@n2100.arm.linux.org.uk> <1318009239.1644.38.camel@Joe-Laptop> <20111007191822.GA26805@n2100.arm.linux.org.uk> <1318016901.11045.9.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318016901.11045.9.camel@Joe-Laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 12:48:21PM -0700, Joe Perches wrote:
> On Fri, 2011-10-07 at 20:18 +0100, Russell King - ARM Linux wrote:
> > On Fri, Oct 07, 2011 at 10:40:39AM -0700, Joe Perches wrote:
> > > At some point in the next couple of years, I want
> > > to convert all of, or as many as possible of, the
> > > remaining printk uses to pr_<level>.
> > If the idea is also to get rid of printk() too (which IMHO would be a
> > good thing as it kills off the constant need to continually patch for
> > missing KERN_ prefixes) then that's a good reason (provided Linus
> > accepts the idea.)
> 
> I don't accept that idea yet.
> 
> There are about 50K printks vs 20K pr_<level>s
> in kernel source.
> 
> I think 50K lines is _way_ too many to convert
> in a couple of years.
> 
> I think it needs to be done subsystem by subsystem,
> arch by arch, as maintainers accept.

Agreed - but doing one instance here, maybe another instance somewhere
else, and come the merge window having several of these patches
scattered around with no real coherent "this is what we're doing, and
its all done for this bit of the tree" kind of story is not the way to
do it.

It would be good to get core code done, or a sub-arch, and then say
"we're not accepting any patch which re-introduces the problem"...
It's a little late in the cycle for that now though.
