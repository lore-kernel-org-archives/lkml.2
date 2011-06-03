Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab1FCNQH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 09:16:07 -0400
Received: from relay1.sgi.com ([192.48.179.29]:54431 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab1FCNQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 09:16:06 -0400
Date: Fri, 3 Jun 2011 08:17:35 -0500
From: Jack Steiner <steiner@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x66, UV: Enable 64-bit ACPI MFCG support for SGI UV2
	platform
Message-ID: <20110603131735.GB15564@sgi.com>
References: <20110602195943.GA27079@sgi.com> <20110603082845.GC16694@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110603082845.GC16694@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03, 2011 at 10:28:45AM +0200, Ingo Molnar wrote:
> 
> * Jack Steiner <steiner@sgi.com> wrote:
> 
> > Enable 64-bit ACPI MFCG support for SGI UV2 platform. The check is similar
> > to the check on UV1. UV2 has a different oem_id string.
> > 
> > Signed-off-by: Jack Steiner <steiner@sgi.com>
> > 
> > 
> > ---
> >  arch/x86/pci/mmconfig-shared.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > Index: linux/arch/x86/pci/mmconfig-shared.c
> > ===================================================================
> > --- linux.orig/arch/x86/pci/mmconfig-shared.c	2011-05-31 12:13:19.635285219 -0500
> > +++ linux/arch/x86/pci/mmconfig-shared.c	2011-06-02 14:41:26.645034257 -0500
> > @@ -519,7 +519,8 @@ static int __init acpi_mcfg_check_entry(
> >  	if (cfg->address < 0xFFFFFFFF)
> >  		return 0;
> >  
> > -	if (!strcmp(mcfg->header.oem_id, "SGI"))
> > +	if (!strcmp(mcfg->header.oem_id, "SGI") ||
> > +	    		!strcmp(mcfg->header.oem_id, "SGI2"))
> 
> Wouldnt strncmp(,,3) cover any future SGI3, SGI4 strings as well?

I considered that but was not certain whether I could safely claim all
oemid's starting with "SGI".

There is a weak precedent in x2apic_uv_x.c - only SGI & SGI2 will be
recognized as an SGI platform. An id such as SGIABC will be treated as
a non SGI platform.

--- jack
