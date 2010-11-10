Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab0KJEpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 23:45:38 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41986 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab0KJEpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 23:45:36 -0500
Date: Tue, 9 Nov 2010 21:45:30 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: David Brownell <david-b@pacbell.net>
Cc: davinci-linux-open-source@linux.davincidsp.com,
        spi-devel-general@lists.sourceforge.net,
        broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rpurdie@rpsys.net, Cyril Chemparathy <cyril@ti.com>
Subject: Re: [PATCH v4 08/12] gpio: add ti-ssp gpio driver
Message-ID: <20101110044530.GB4110@angua.secretlab.ca>
References: <1288124308-14999-9-git-send-email-cyril@ti.com>
 <956998.65651.qm@web180302.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <956998.65651.qm@web180302.mail.gq1.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 07:15:16PM -0700, David Brownell wrote:
> 
> 
> --- On Tue, 10/26/10, Cyril Chemparathy <cyril@ti.com> wrote:
> 
> > From: Cyril Chemparathy <cyril@ti.com>
> > Subject: [PATCH v4 08/12] gpio: add ti-ssp gpio driver
> 
> On the assumptions you've tested this *AND* will
> resubmit with the previously-requested change of
> removing all references to non-existent
> "virtual"ness in the driver ... I'll likely
> add my ack to that resubmitted version
> 
> Also, chip2gpio seems an excessively generic name;
> maybe chip2_ti_ssp_gpio or somesuch?
> 
> I'd still be happier seeing this "stack" packaged
> as a hardware library called by various drivers
> (like GPIO, SPI, etc) rather than a core driver
> that's called by other drivers.  That seems like
> a better structure for various vendors' "SSP"
> hardware (multifunction serial interface logic)
> since most function drivers just need to poke
> the registers a bit differently, and don't have
> much to share with a "core driver" beyond a few
> setup routines (if that).

I thought the point of this device was that a single device hosted a
pair of multi-function serial interfaces, with each implementing a
separate function.  If so, then it makes sense for the base driver to
register child devices of the appropriate kinds.

g.

