Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab1FUMsy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 08:48:54 -0400
Received: from linux-sh.org ([111.68.239.195]:55400 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347Ab1FUMsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 08:48:53 -0400
Date: Tue, 21 Jun 2011 21:47:43 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Magnus Damm <magnus.damm@gmail.com>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org
Subject: Re: [Update][PATCH 8/8] ARM / shmobile: Support for I/O power domains for SH7372 (v6)
Message-ID: <20110621124742.GK7920@linux-sh.org>
References: <201106112223.04972.rjw@sisk.pl> <20110620020125.GA26125@linux-sh.org> <201106210030.01922.rjw@sisk.pl> <201106211357.09202.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106211357.09202.rjw@sisk.pl>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 01:57:08PM +0200, Rafael J. Wysocki wrote:
> On Tuesday, June 21, 2011, Rafael J. Wysocki wrote:
> > On Monday, June 20, 2011, Paul Mundt wrote:
> > > Given that these functions can return errors, it's probably more prudent
> > > to implement some timeout logic on top of the busy loop. Hardware does
> > > get stuck, after all.
> > 
> > Yes, it does, but we don't really know what timeout value to use in there.
> > 
> > In fact, failures of pd_power_down() don't really matter (at worst the power
> > domain won't be powered off really) and pd_power_up() should only return error
> > code if the error is known to be unrecoverable.
> > 
> > So, what about this: repeat certain number of times (I verified that it took
> > several iterations of the loop until the new value settled on my hardware)
> > and then return from pd_power_down() or go to sleep for a short time and repeat
> > in pd_power_up()?
> 
> Having discussed that with Magnus I changed pd_power_down() to use a timeout.
> Specifically, it will bail out if the state doesn't change after approximately
> 1 ms.
> 
Looks good to me, thanks for fixing it up.

Acked-by: Paul Mundt <lethal@linux-sh.org>
