Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab1LATqO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 14:46:14 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:48931 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab1LATqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 14:46:12 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+Fz3lJDLQD6RcryO05x4AS
Date: Thu, 1 Dec 2011 11:46:09 -0800
From: Tony Lindgren <tony@atomide.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Paul Walmsley <paul@pwsan.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2a/5] Remove unsafe clock values from omap1_defconfig
Message-ID: <20111201194609.GX31337@atomide.com>
References: <20111128174508.GO31337@atomide.com>
 <201112011938.36706.jkrzyszt@tis.icnet.pl>
 <20111201190455.GV31337@atomide.com>
 <201112012023.04635.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112012023.04635.jkrzyszt@tis.icnet.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [111201 10:48]:
> On Thursday 01 of December 2011 at 20:04:55, Tony Lindgren wrote:
> > 
> > From: Tony Lindgren <tony@atomide.com>
> > Date: Thu, 1 Dec 2011 11:00:11 -0800
> > Subject: [PATCH] ARM: OMAP1: Fix reprogramming of DPLL1 for systems that boot at rates below 60MHz
> > 
> > Commit e9b7086b80c4d9e354f4edc9e280ae85a60df408 (ARM: OMAP: Fix
> > reprogramming of dpll1 rate) fixed a regression for systems that
> > did not rely on bootloader set rates.
> > 
> > However, it also introduced a new problem where the rates selected
> > in .config would not take affect as omap1_select_table_rate
> > currently refuses to reprogram DPLL1 if it's already initialized.
> > 
> > This was not a problem earlier, as the reprogramming was done
> > earlier with ck_dpll1_p->rate uninitialized.
> > 
> > Fix this by forcing the reprogramming on systems booting at rates
> > below 60MHz. Note that the long term fix is to make the rates
> > SoC specific later on.
> > 
> > Thanks for Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> for figuring
> > this one out.
> > 
> > Reported-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> > Signed-off-by: Tony Lindgren <tony@atomide.com>
> 
> Acked-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> 
> However, this way or another, we are back to your mentioned problem of 
> omap1_defconfig always switching to 216 MHz, I'm afraid. Then, 2a/5 v1 
> "Remove unsafe clock values from omap1_defconfig" can still be helpful.

OK that makes sense now also in case there are other systems that
boot at rates below 60MHz.
 
> Anyway, I'm resending (refreshed) 2/5 and 5/5 as rc fixes as you 
> suggested before, 1/5 "ARM: OMAP1: Fix dpll1 default rate reprogramming 
> method" intended for next, and 2a/5 v2 "ARM: OMAP1: select clock rate by 
> CPU type" also for next but as an RFC. 

Great, sounds like we got the fixes needed for the -rc cycle then.

Regards,

Tony
