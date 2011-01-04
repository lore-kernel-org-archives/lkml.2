Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301Ab1ADWYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 17:24:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36833 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946Ab1ADWYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 17:24:44 -0500
Date: Tue, 4 Jan 2011 13:34:14 -0800
From: Greg KH <gregkh@suse.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 0/2] Annotate gpio-configuration with __must_check
Message-ID: <20110104213414.GA6774@suse.de>
References: <1294159868-4989-1-git-send-email-w.sang@pengutronix.de>
 <20110104202718.GA31444@suse.de>
 <20110104212916.GA14436@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110104212916.GA14436@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 10:29:16PM +0100, Wolfram Sang wrote:
> On Tue, Jan 04, 2011 at 12:27:18PM -0800, Greg KH wrote:
> > On Tue, Jan 04, 2011 at 05:51:06PM +0100, Wolfram Sang wrote:
> > > Here is a small series generating a lot of warnings, especially in board
> > > bringup-files. Still, I think it is worthwhile to be strict about checking
> > > return values of gpio-configuration-functions. My suggestion to keep the noise
> > > a bit lower is to put it into linux-next for one cycle and then merge it for
> > > 2.6.39? That should give people some time to fix the issues in time. Looking
> > > forward to comments.
> > 
> > It's ok to add this type of thing, but please, go through and fix the
> > warnings at the same time.  Otherwise it's a bit rude to force others to
> > fix their code for something that you did.
> 
> Yeah, I understand. I was a "victim" of the patch causing all those "key not in
> .data" messages back then. So, I actually did start a coccinelle-script fixing
> the issues. I examined one sub-directory using a CPU/SoC I know relatively
> well. I had to learn that even then, it is pretty hard to determine what
> exactly to do if gpio_request() fails. For example, an unavailable GPIO being
> the write-protect-pin for SD-cards might be simply ignored, maybe a warning
> printed and the card will be rw by default. Another GPIO might be a chip-select
> of a device I have never heard of before. It might be crucial and board_init
> should fail if it cannot be requested. Or not. Things get worse for
> architectures I never used before. This is why I think it is really better to
> let people do the fixups who have/understand the hardware in question.
> Otherwise the fixups could indeed be more harmful than helpful.

Sure, they could be more harmful, but at least try.  Make the patches
up, submit them to the maintainers, and if they are wrong, they will be
the best to fix it up properly.

> If this is still too rude for your taste, then what about a mechanism similar
> to DEBUG_SECTION_MISMATCH?

No, that's still annoying :)

thanks,

greg k-h
