Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab2FMHbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 03:31:20 -0400
Received: from linux-sh.org ([111.68.239.195]:55575 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778Ab2FMHbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 03:31:18 -0400
Date: Wed, 13 Jun 2012 16:31:14 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] irqdomain: Support for static IRQ mapping and
 association.
Message-ID: <20120613073114.GM10170@linux-sh.org>
References: <1337576792-5347-1-git-send-email-lethal@linux-sh.org>
 <1337576792-5347-2-git-send-email-lethal@linux-sh.org>
 <20120526015049.1616D3E2336@localhost>
 <20120611032547.GB10170@linux-sh.org>
 <CACxGe6sRVk3sef0X9Q_FDcMx5=y0mKJ-pUM-S2-CitUFQ7koGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACxGe6sRVk3sef0X9Q_FDcMx5=y0mKJ-pUM-S2-CitUFQ7koGA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2012 at 11:02:16PM -0600, Grant Likely wrote:
> On Sun, Jun 10, 2012 at 9:25 PM, Paul Mundt <lethal@linux-sh.org> wrote:
> > On Fri, May 25, 2012 at 07:50:49PM -0600, Grant Likely wrote:
> >> It would be really good to make sure the hwirqs aren't already
> >> associated before trying to associate them again. ?Unfortunately that
> >> can't be done (nicely) until I get rid of the slow path lookup. ?I've
> >> got a patch for that which I'll rebase on top of this one and post soon.
> >>
> > Any updates on this? I have quite a few more changes I intend on making,
> > but there's no point in starting in on that until these existing patches
> > are sorted out.
> 
> Yeah, I made some progress and have a whole bunch of patches to post
> which I had hoped to do last week.  Unfortunately the move to the UK
> has meant that the last 7 days have been non-stop cleaning, packing
> and throwing out stuff.  I've not been able to do a final cleanup.
> The house gets cleaned on Tuesday so it can go on the market on
> Wednesday which means all the house stuff must be done by Monday
> evening.  Hopefully I'll get some time on Tuesday to do some hacking.
> 
No worries, life happens. Just wanted to make sure you hadn't forgotten
about them!

> If you want to look at them I've pushed them out to the irqdomain/test
> branch on git.secretlab.ca.
> 
Thanks, I've fetched them and been hacking on them a bit. Fortunately you
already did some the work I had intended on doing, particularly in
relation to slow vs fast-path lookups, so there hasn't been much more for
me to do.

That being said, you forgot about legacy domains with non-zero hwirq
bases in your legacy -> linear revmap conversion, so some (or all) of
those IRQs will now find themselves stuffed in the radix tree instead..

I already got bitten by this trying to figure out why my batched disposal
helper wasn't doing its job and my linear domain was tripping over the
non-zero radix root height warn at domain removal time, so that's fixed
now.

Patches to follow (also in the common/irqdomain topic branch in my github
tree).
