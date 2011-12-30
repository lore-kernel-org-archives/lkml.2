Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751191Ab1L3Pav (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 10:30:51 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61642 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab1L3Pat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 10:30:49 -0500
Message-ID: <4EFDD925.3050806@gmail.com>
Date: Fri, 30 Dec 2011 09:30:45 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: David Daney <ddaney.cavm@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH v2 0/4] irq/of: Cleanup and Enchance irq_domain support.
References: <1323916330-8865-1-git-send-email-ddaney.cavm@gmail.com>
In-Reply-To: <1323916330-8865-1-git-send-email-ddaney.cavm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On 12/14/2011 08:32 PM, David Daney wrote:
> From: David Daney <david.daney@cavium.com>
> 
> Back in early Nov. I send the first version of this patch set.  Now
> things are heating up again in the world of irq_domain, so I wanted to
> try to get some closure on the issues I had.  The Octeon patch is
> included here to show how I am using irq_domain, but is part of a much
> larger effort to merge Octeon device tree support.
> 
> The basic problem I am attempting to solve is using irq domains when
> there is a 'non-linear' mapping of hwirq <--> irq within a domain.
> Octeon has a single set of irq numbers that is used across two
> different implementations of the interrupt controller as well as more
> than 10 different SOCs all which use different subsets of the irq
> number space.  The result is that the hwirq to irq mapping function
> contains many gaps and discontinuities, it is really quite random.
> 
> The existing irq domain infrastructure assumes a continuous linear
> mapping of hwirq to irq that can be encapsulated by the irq_base,
> hwirq_base and nr_irq elements of struct irq_domain.  This is not
> suitable for the Octeon implementation.
> 
> The gist of my change is to add an optional iterator function to
> irq_domain_ops which knows how to iterate over the irq numbers in a
> given domain.  For simple linear domains (those currently supported),
> we iterate using the current method based on irq_base, hwirq_base and
> nr_irq.
> 
> Summary of the patches:
> 
> 1) Get rid of some unused code to make subsequent changes simpler.
> 
> 2) Cleanup the data type used by various hwirq functions and users.
> 
> 3) Add the irq iterator, and fix up the ARM GIC code to use it instead
> of the current irq_domain_for_each_irq().
> 
> 4) Add the Octeon users of the interface.
> 
> In an earlier exchange, Rob Herring had said:
> 
>    ... Handling sparse irqs is a potentially common problem, so we
>    should address that in the core irqdomain code.
> 
> Which is what this patch set is doing.
> 
> There was a suggestion that perhaps having .to_irq() return a magic
> value if there was no mapping would also work.  However I prefer this
> approach as it separates the concepts of iteration and mapping of irq
> numbers.
> 
> Please comment.

Can we first have a patch that just allows irq domains to be enabled on
MIPS. It collides because of multiple versions of irq_create_of_mapping.

Rob
