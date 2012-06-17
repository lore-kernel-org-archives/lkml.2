Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602Ab2FQWQ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 18:16:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39328 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab2FQWQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 18:16:28 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 03/12] irqdomain: Support for static IRQ mapping and association.
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, Milton Miller <miltonm@bga.com>,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>
In-Reply-To: <1339826319.9220.221.camel@pasglop>
References: <1339822897-15840-1-git-send-email-grant.likely@secretlab.ca> <1339822897-15840-4-git-send-email-grant.likely@secretlab.ca> <1339826319.9220.221.camel@pasglop>
Date: Sun, 17 Jun 2012 16:16:25 -0600
Message-Id: <20120617221625.97ED63E05C0@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Jun 2012 15:58:39 +1000, Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> On Fri, 2012-06-15 at 23:01 -0600, Grant Likely wrote:
> > From: Paul Mundt <lethal@linux-sh.org>
> > 
> > This adds a new strict mapping API for supporting creation of linux IRQs
> > at existing positions within the domain. The new routines are as follows:
> > 
> > For dynamic allocation and insertion to specified ranges:
> > 
> > 	- irq_create_identity_mapping()
> > 	- irq_create_strict_mappings()
> 
> How does that differ from NOMAP ? Any reason to add that rather than use
> NOMAP and some offset built into the PIC driver ?

Ultimately it simplifies the code.  It allows the irq controller to
specify arbitrary ranges of hwirq->irq mappings without any special
processing.  Some of the irq controllers have multiple hwirq ranges
that need to be mapped, and this is a reasonable approach for doing so
regardless of the revmap type.

Ideally I'd rather not do any of this and have the virqs dynamically
assigned, but as long as there are still platforms relying on static
platform_data it will be required.

g.

