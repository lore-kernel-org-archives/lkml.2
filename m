Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab1KOC7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 21:59:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:11005 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755378Ab1KOC7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 21:59:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="75399237"
Message-ID: <1321325960.13860.75.camel@yhuang-dev>
Subject: Re: Printk mulitple line message support
From: Huang Ying <ying.huang@intel.com>
To: Joe Perches <joe@perches.com>
Cc: William Douglas <william.r.douglas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 15 Nov 2011 10:59:20 +0800
In-Reply-To: <1321324217.8944.25.camel@Joe-Laptop>
References: <1321253936.13860.35.camel@yhuang-dev>
	 <1321281640.2004.6.camel@Joe-Laptop> <1321318201.13860.51.camel@yhuang-dev>
	 <1321319883.8944.7.camel@Joe-Laptop> <1321321957.13860.64.camel@yhuang-dev>
	 <1321324217.8944.25.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-15 at 10:30 +0800, Joe Perches wrote:
> On Tue, 2011-11-15 at 09:52 +0800, Huang Ying wrote:
> > On Tue, 2011-11-15 at 09:18 +0800, Joe Perches wrote:
> > > I believe you are not solving any real problem
> > > with pr_<level>_ml.
> > > Most all interleaved complete line uses have some
> > > pr_fmt prefix that distinguishes between the sources.
> > Except dev_<level> and netdev_<level>, it appears that many general
> > pr_<level> do not have the prefix.
> 
> I'm working on that.
> There are a lot of them and it's a slog.

Em...  so you think we do not need a general solution?  Just use various
prefix for these pr_<level>?

The down side of this solution is that it is hard to use a simple script
to distinguish interleaved message easily.

> > > A perhaps larger problem is interleaved partial
> > > lines with pr_cont.
> > In an interleaved situation, how to determine <level> for pr_cont?
> 
> pr_cont has its own KERN_CONT level, it's "<c>", which
> is stripped from output by printk.  It's used to continue
> the previous printks output on a single line.

Sorry.  Had some misunderstanding about pr_cont.
 
> > > I believe that an initiator/terminator is necessary
> > > for reassembly.  Something that could be used
> > > with pr_<level>, dev_<level>, netdev_<level>, et al.
> > > 
> > > mp_start(&cookie)
> > > pr_<level>(fmt, ...);
> > 
> > Do not need cookie here?
> 
> Ideally not.
> 
> > > pr_mp_cont(&cookie, fmt, ...);
> > > pr_mp_cont(&cookie, fmt "\n", ...);
> > > mp_end(&cookie);
> > 
> > With initiator/terminator the kernel log will be more structural, but
> > that will make kernel log a little harder to read too.
> 
> Initiator/terminator would not be part of printk output
> but could exist simply to set/track the atomic/cookie #
> and have printk output the appropriate cookie id when
> more than 1 cookie is active.

Oh.  I see.

For multiple part in one line.  I think the better solution may be to
assemble them in a line buffer before real output to console to avoid
interleaving.  Do you think so?

Best Regards,
Huang Ying


