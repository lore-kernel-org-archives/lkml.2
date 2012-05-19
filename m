Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641Ab2ESG5N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 02:57:13 -0400
Received: from linux-sh.org ([111.68.239.195]:45455 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754434Ab2ESG5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 02:57:11 -0400
Date: Sat, 19 May 2012 15:57:04 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Joe Perches <joe@perches.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] irqdomain: trivial pr_fmt conversion.
Message-ID: <20120519065704.GB32537@linux-sh.org>
References: <1337407908-7421-1-git-send-email-lethal@linux-sh.org> <1337407908-7421-8-git-send-email-lethal@linux-sh.org> <1337409295.10521.4.camel@joe2Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337409295.10521.4.camel@joe2Laptop>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 11:34:55PM -0700, Joe Perches wrote:
> On Sat, 2012-05-19 at 15:11 +0900, Paul Mundt wrote:
> > Convert to pr_fmt before things start to get out of hand and some
> > janitors start getting overly excited.
> 
> ;)  OK then, here's some trivia:
> 
> > diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> []
> > @@ -1,3 +1,5 @@
> > +#define pr_fmt(fmt)  "irq: " fmt
> 
> "irqdomain: " (KBUILD_MODNAME) may be more sensible
> 
Perhaps. The point of the patch was to consolidate rather than change
behaviour. With a consolidation in place it's possible to change it to
whatever people are happy with.

> []
> > @@ -410,23 +412,23 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
> >  	unsigned int hint;
> >  	int virq;
> >  
> > -	pr_debug("irq: irq_create_mapping(0x%p, 0x%lx)\n", domain, hwirq);
> > +	pr_debug("irq_create_mapping(0x%p, 0x%lx)\n", domain, hwirq);
> 
> "%s: ...", __func__, etc...
> 
Unrelated to pr_fmt conversion. In any event, these debug calls are
unlikely to hang around for very long.

> >  	if (domain == NULL) {
> > -		printk(KERN_WARNING "irq_create_mapping called for"
> > -		       " NULL domain, hwirq=%lx\n", hwirq);
> > +		pr_warning("irq_create_mapping called for"
> > +			   " NULL domain, hwirq=%lx\n", hwirq);
> 
> 		pr_warn("%s: called with NULL domain, hwirq=%lx\n", hwirq);
> 
No. pr_warning() matches the log level, pr_warn() does not. A quick grep
also shoes more pr_warning() users than pr_warn(), so it sounds like you
have your work cut out for you. Good luck.
