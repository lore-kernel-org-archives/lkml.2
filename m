Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760639Ab2FUXQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 19:16:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37933 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab2FUXQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 19:16:01 -0400
Date: Thu, 21 Jun 2012 16:15:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, zheng.z.yan@intel.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf/x86: Add generic Intel uncore PMU support
Message-Id: <20120621161558.824d7c6b.akpm@linux-foundation.org>
In-Reply-To: <4FE3A9DF.20303@zytor.com>
References: <1339741902-8449-6-git-send-email-zheng.z.yan@intel.com>
	<tip-087bfbb032691262f2f7d52b910652450c5554b8@git.kernel.org>
	<20120621154334.05a74517.akpm@linux-foundation.org>
	<4FE3A495.1030008@zytor.com>
	<20120621155159.239aa972.akpm@linux-foundation.org>
	<4FE3A9DF.20303@zytor.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2012 16:10:23 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 06/21/2012 03:51 PM, Andrew Morton wrote:
> > 
> > What *is* significant is the effect of a signedness change upon
> > arithmetic, conversions, warnings, etc.  And whether such a change
> > might actually introduce bugs.
> > 
> > 
> > Back away and ask the broader questions: why did ktime_t choose
> > unsigned?  Is time a signed concept?  What is the right thing to do
> > here, from a long-term design perspective?
> 
> Time is definitely a signed concept -- it has no beginning or end (well,
> the Big Bang, but the __110 Myr or so uncertainty of the exact timing of
> the Big Bang makes it a horridly awkward choice for epoch.)
> 
> Now, for some users of time you can inherently guarantee there will
> never be any references to time before a particular event, e.g. system
> boot, in which case an unsigned number might make sense, but as a whole
> I think using a signed type as time_t in nearly all Unix implementation
> was The Right Thing.
> 

So why is ktime_t unsigned?
