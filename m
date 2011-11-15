Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab1KOCaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 21:30:19 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:35764 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755059Ab1KOCaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 21:30:18 -0500
Message-ID: <1321324217.8944.25.camel@Joe-Laptop>
Subject: Re: Printk mulitple line message support
From: Joe Perches <joe@perches.com>
To: Huang Ying <ying.huang@intel.com>
Cc: William Douglas <william.r.douglas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 14 Nov 2011 18:30:17 -0800
In-Reply-To: <1321321957.13860.64.camel@yhuang-dev>
References: <1321253936.13860.35.camel@yhuang-dev>
	 <1321281640.2004.6.camel@Joe-Laptop> <1321318201.13860.51.camel@yhuang-dev>
	 <1321319883.8944.7.camel@Joe-Laptop> <1321321957.13860.64.camel@yhuang-dev>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-15 at 09:52 +0800, Huang Ying wrote:
> On Tue, 2011-11-15 at 09:18 +0800, Joe Perches wrote:
> > I believe you are not solving any real problem
> > with pr_<level>_ml.
> > Most all interleaved complete line uses have some
> > pr_fmt prefix that distinguishes between the sources.
> Except dev_<level> and netdev_<level>, it appears that many general
> pr_<level> do not have the prefix.

I'm working on that.
There are a lot of them and it's a slog.

> > A perhaps larger problem is interleaved partial
> > lines with pr_cont.
> In an interleaved situation, how to determine <level> for pr_cont?

pr_cont has its own KERN_CONT level, it's "<c>", which
is stripped from output by printk.  It's used to continue
the previous printks output on a single line.
 
> > I believe that an initiator/terminator is necessary
> > for reassembly.  Something that could be used
> > with pr_<level>, dev_<level>, netdev_<level>, et al.
> > 
> > mp_start(&cookie)
> > pr_<level>(fmt, ...);
> 
> Do not need cookie here?

Ideally not.

> > pr_mp_cont(&cookie, fmt, ...);
> > pr_mp_cont(&cookie, fmt "\n", ...);
> > mp_end(&cookie);
> 
> With initiator/terminator the kernel log will be more structural, but
> that will make kernel log a little harder to read too.

Initiator/terminator would not be part of printk output
but could exist simply to set/track the atomic/cookie #
and have printk output the appropriate cookie id when
more than 1 cookie is active.


