Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583Ab1CCThJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 14:37:09 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:50614 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708Ab1CCThI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 14:37:08 -0500
Date: Thu, 3 Mar 2011 12:37:05 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Roland Stigge <stigge@antcom.de>
Cc: linux-kernel@vger.kernel.org, info@pengutronix.de
Subject: Re: [PATCH] max730x: Added setup/teardown hooks
Message-ID: <20110303193705.GA10391@angua.secretlab.ca>
References: <1297425606-13290-1-git-send-email-stigge@antcom.de>
 <AANLkTimUd1WQ2G0W0D0DLt+-bvdwxw9aZx6tgjno8ym=@mail.gmail.com>
 <4D6FEB74.7050503@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6FEB74.7050503@antcom.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 08:26:44PM +0100, Roland Stigge wrote:
> On 03/03/2011 07:59 PM, Grant Likely wrote:
> > On Fri, Feb 11, 2011 at 5:00 AM,  <stigge@antcom.de> wrote:
> >> max730x: Added setup/teardown hooks
> >>
> >> This patch adds setup and teardown hooks for configuration of GPIO lines via
> >> platform_data, similar to the pca953x driver.
> > 
> > Why?  What actions are these hooks going to perform?
> 
> In board configurations, ARM systems are set up with GPIO lines
> configured as Input or Output etc. See also arch/arm/*/*. See usage of
> pca953x - how it is already done there.

It appears to simply be notifying the platform code that the gpio chip
has been registered.  My point is that it doesn't seem to make any
sense whatsoever to have driver specific hooks to inform platform code
that a gpio controller has shown up.  It is something that should be
part of the infrastructure.  I would much rather see this get
implemented with a notifier or something similar in gpiochip_add().

Other drivers may currently be doing driver-specific callbacks, but it
is a bad pattern and I don't want any more drivers to do so.

g.

