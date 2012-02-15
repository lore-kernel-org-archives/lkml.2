Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab2BOUVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 15:21:50 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47934 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080Ab2BOUVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 15:21:49 -0500
Date: Wed, 15 Feb 2012 13:21:45 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: devicetree-discuss@lists.ozlabs.org, Rob Herring <rob.herring@calxeda.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        Milton Miller <miltonm@bga.com>, Thomas Gleixner <tglx@linutronix.de>,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 24/25] irq_domain: remove "hint" when allocating irq
 numbers
Message-ID: <20120215202145.GH25779@ponder.secretlab.ca>
References: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
 <1327700179-17454-25-git-send-email-grant.likely@secretlab.ca>
 <4F316848.4060100@atmel.com>
 <4F3BC97C.6030203@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F3BC97C.6030203@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 04:04:28PM +0100, Nicolas Ferre wrote:
> On 02/07/2012 07:07 PM, Nicolas Ferre :
> > On 01/27/2012 10:36 PM, Grant Likely :
> >> The 'hint' used to try and line up irq numbers with hw irq numbers is
> >> rather a hack and not very useful.  Now that /proc/interrupts also outputs
> >> the hwirq number, it is even less useful to keep around the 'hint' heuristic.
> >>
> >> This patch removes it.
> > 
> > Grant,
> > 
> > While trying your patch series in conjunction with Rob one, I do not
> > find this patch in your irqdomain/next branch (and a couple of others).
> > Can you tell me if this v3 series is available as a git tree?
> 
> I am still interested by patch 24-25 of this series but still cannot
> find them in your irqdomain/next branch:
> Are they also expected to join the 3.4 merge window material?

I've held off on putting them in irqdomain/next because they are a bit more
risky than the other patches, and I want an explicit ack from Ben for patches
24 & 25.  However, that shouldn't really cause any issues since the changes
in 24 & 25 don't impact the irq_domain functionality or API.  They are just
optimizations.

Also on 25, I'm not yet convinced that breaking out the revmap functions
into ops is the right thing to do.  It actually makes the .text size quite
a bit larger.  I may very well rewrite it.

g.

