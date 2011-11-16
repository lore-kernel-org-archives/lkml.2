Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808Ab1KPAys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 19:54:48 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:53305 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932742Ab1KPAyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 19:54:47 -0500
Message-ID: <1321404886.21286.33.camel@Joe-Laptop>
Subject: Re: Printk mulitple line message support
From: Joe Perches <joe@perches.com>
To: Huang Ying <ying.huang@intel.com>
Cc: William Douglas <william.r.douglas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 15 Nov 2011 16:54:46 -0800
In-Reply-To: <1321404338.13860.85.camel@yhuang-dev>
References: <1321253936.13860.35.camel@yhuang-dev>
	 <1321281640.2004.6.camel@Joe-Laptop> <1321318201.13860.51.camel@yhuang-dev>
	 <1321319883.8944.7.camel@Joe-Laptop> <1321321957.13860.64.camel@yhuang-dev>
	 <1321324217.8944.25.camel@Joe-Laptop>
	 <1321404338.13860.85.camel@yhuang-dev>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-16 at 08:45 +0800, Huang Ying wrote:
> On Tue, 2011-11-15 at 10:30 +0800, Joe Perches wrote:
> > On Tue, 2011-11-15 at 09:52 +0800, Huang Ying wrote:
> > > On Tue, 2011-11-15 at 09:18 +0800, Joe Perches wrote:
> > > > I believe you are not solving any real problem
> > > > with pr_<level>_ml.
> > > > Most all interleaved complete line uses have some
> > > > pr_fmt prefix that distinguishes between the sources.
> > > Except dev_<level> and netdev_<level>, it appears that many general
> > > pr_<level> do not have the prefix.
> > I'm working on that.
> > There are a lot of them and it's a slog.
> What's your solution here?

Coalesce the multiple printks to a single printk
without KERN_CONT use at all.

For example: commit 94f05b0f60de32

> Fix multiline pr_<level> one by one with
> various prefix?

Yes, though I believe multiline_pr_<level>
isn't particularly valuable.

> How about lines with same prefix comes from different
> CPU?

Generally, emitting complete lines even from the same
module via multiple threads from a single or multiple
cpus can be intelligibly interleaved without issue.

I believe it's the printks that use KERN_CONT and the
printks without terminating newlines that are the
problems that need to be resolved somehow.

cheers, Joe

