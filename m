Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab1KGX1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 18:27:20 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:41362 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab1KGX1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 18:27:19 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+HPIJ4PR8NZI6LmrP+Fdcp
Date: Mon, 7 Nov 2011 15:27:13 -0800
From: Tony Lindgren <tony@atomide.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Paul Walmsley <paul@pwsan.com>, Felipe Balbi <balbi@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm: omap2+: hwmod: fix breakage introduced by d6504acd
Message-ID: <20111107232713.GD31337@atomide.com>
References: <1320688617-4543-1-git-send-email-balbi@ti.com>
 <20111107183208.GG15294@n2100.arm.linux.org.uk>
 <20111107193908.GA5059@legolas.emea.dhcp.ti.com>
 <20111107212707.GH15294@n2100.arm.linux.org.uk>
 <alpine.DEB.2.00.1111071428001.12394@utopia.booyaka.com>
 <20111107224129.GJ15294@n2100.arm.linux.org.uk>
 <20111107225157.GB31337@atomide.com>
 <20111107225529.GK15294@n2100.arm.linux.org.uk>
 <20111107230728.GC31337@atomide.com>
 <20111107231632.GL15294@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111107231632.GL15294@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King - ARM Linux <linux@arm.linux.org.uk> [111107 14:41]:
> On Mon, Nov 07, 2011 at 03:07:28PM -0800, Tony Lindgren wrote:
> > * Russell King - ARM Linux <linux@arm.linux.org.uk> [111107 14:20]:
> > > On Mon, Nov 07, 2011 at 02:51:57PM -0800, Tony Lindgren wrote:
> > > > Here's what I got. Looks like the removal of the sr[12]_hwmod
> > > > part is no longer needed, so only the r value check part is needed.
> > > 
> > > Err.  So do you have anything in your git tree which you're pushing out
> > > this evening which removes the sr[12]_hwmod from the omap_3xxx_hwmod
> > > list?
> > > 
> > > If not, how does that bug get fixed in mainline?
> > 
> > Ah sorry, there's also the following commit there that deals
> > with other related issues:
> 
> Great, so it looks like everything that I've found over the last two days
> should be solved completely by what you have queued for Arnd.

OK good to hear.

> One last issue though...
> 
> We had this patch:
> 
> http://lists.arm.linux.org.uk/lurker/message/20111006.232441.227dfcf6.en.html
> 
> which is from Paul, post my complaint about IS_ERR_VALUE being used.
> This removed sr1_hwmod and sr2_hwmod, and the commit message explicitly
> talks about doing this.
> 
> There's also the patch below.  Somehow, this resulted in that bit of
> Paul's patch being removed (possibly automatically by git) but the commit
> comments are retained, which are now stale and no longer reflect what the
> patch is doing...  That's rather unfortunate, but at this point its
> probably too late to do something about it.

Yeah that's a bit unfortunate. At least the commit message mentions
what it fixes, and then mentions the secondary bug related to the
sr[12]_hwmod entries. Anyways, I'd rather not start messing with commit
unless people think it's worth rebasing about half of the patches
in fixes.

Regards,

Tony
