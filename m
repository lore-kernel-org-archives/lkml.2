Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab0FNUrL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 16:47:11 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54065 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350Ab0FNUrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 16:47:10 -0400
Date: Mon, 14 Jun 2010 21:47:01 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: minyard@acm.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipmi: Make sure drivers were registered before
	unregistering them
Message-ID: <20100614204701.GA32612@srcf.ucam.org>
References: <1276192406-3612-1-git-send-email-mjg@redhat.com> <20100614133608.b343cb84.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614133608.b343cb84.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 01:36:08PM -0700, Andrew Morton wrote:
> On Thu, 10 Jun 2010 13:53:26 -0400
> Matthew Garrett <mjg@redhat.com> wrote:
> 
> > The ipmi code will never register a PCI or Open Firmware driver if
> > a hardcoded device is provided by the user.
> 
> How does a user "provide a hardcoded device"?

By providing device addresses via the module parameters. This is the 
terminology used in the driver.

> I tried to work out from the above whether we want to backport this fix
> into -stable and failed.  And I reckon that if I can't work this out
> from a changelog, the changelog is inadequate.

We don't. The change that caused this bug was merged post-.34.

> >  #ifdef CONFIG_ACPI
> > @@ -3330,6 +3338,7 @@ static __devinit int init_ipmi_si(void)
> >  
> >  #ifdef CONFIG_PPC_OF
> >  	of_register_platform_driver(&ipmi_of_platform_driver);
> > +	of_registered = 1;
> 
> I assume the code will still oops if of_register_platform_driver() failed.

Indeed. I should fix that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
