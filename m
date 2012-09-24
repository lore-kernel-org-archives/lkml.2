Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab2IXRTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 13:19:42 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61417 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755312Ab2IXRTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 13:19:41 -0400
Date: Mon, 24 Sep 2012 18:19:35 +0100
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: hw_breakpoint: Clear breakpoints before enabling
 monitor mode
Message-ID: <20120924171934.GE5522@mudshark.cambridge.arm.com>
References: <1348160260-19486-1-git-send-email-sboyd@codeaurora.org>
 <20120920173556.GQ4654@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120920173556.GQ4654@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 06:35:56PM +0100, Will Deacon wrote:
> On Thu, Sep 20, 2012 at 05:57:40PM +0100, Stephen Boyd wrote:
> > +/* Determine if halting mode is enabled */
> > +static int halting_mode_enabled(void)
> > +{
> > +	u32 dscr;
> > +
> > +	ARM_DBG_READ(c1, 0, dscr);
> > +
> > +	if (WARN_ONCE(dscr & ARM_DSCR_HDBGEN,
> > +		"halting debug mode enabled. Unable to access hardware resources.\n")) {
> > +		return -EPERM;
> > +	}
> > +	return 0;
> > +}
> 
> ...it looks like debug arch 7.1 defines this bit as UNKNOWN when the OS lock
> is clear, so we probably shouldn't be reading it at all. I'll pour myself a
> stiff drink and start reading the debug arch docs to work out what on Earth
> we should do.
> 
> Stay tuned.

Ok, I've pushed a bunch of patches to my hw-breakpoint branch (head commit
55cb726797c7). I'll post them to the list after the merge window, but please
do take them for a spin if you get a chance.

Will
