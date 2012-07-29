Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab2G2U7H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 16:59:07 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:52291 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629Ab2G2U7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 16:59:05 -0400
Date: Sun, 29 Jul 2012 21:59:00 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andreas Heider <andreas@meetr.de>,
        Arun Raghavan <arun.raghavan@collabora.co.uk>,
        linux-kernel@vger.kernel.org, airlied@redhat.com
Subject: Re: [PATCH] apple-gmux: Restore switch registers on suspend/resume
Message-ID: <20120729205859.GA25819@srcf.ucam.org>
References: <1341891593-6485-1-git-send-email-arun.raghavan@collabora.co.uk>
 <20120710160555.GA31562@srcf.ucam.org>
 <20120710163516.GE10194@thinkpad-t410>
 <4FFCC7FB.1090609@meetr.de>
 <1343522547.2488.12.camel@shinybook.infradead.org>
 <1343524730.1962.5.camel@shinybook.infradead.org>
 <20120729193953.GA25132@srcf.ucam.org>
 <1343595171.2511.1.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343595171.2511.1.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2012 at 09:52:51PM +0100, David Woodhouse wrote:
> On Sun, 2012-07-29 at 20:39 +0100, Matthew Garrett wrote:
> > And it looks like intel_lvds->edid is only set during intel_lvds_init(). 
> > That seems less than ideal. How about something like this entirely 
> > untested patch? 
> 
> Actually, it works if I write 'MIGD' first and then 'IGD'. Looks like we
> aren't switching the DDC over to the new gfx card soon enough in the
> process?

Yes, the call to the switcheroo code only comes after the card is 
powered on. Cc:ing Dave Airlie - what are the expectations here? It 
looks like i915 should have a reprobe function.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
