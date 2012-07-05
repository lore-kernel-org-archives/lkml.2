Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419Ab2GELnp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 07:43:45 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47319 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148Ab2GELnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 07:43:43 -0400
MIME-Version: 1.0
In-Reply-To: <1341487159-3919-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1341487159-3919-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Thu, 5 Jul 2012 14:43:42 +0300
Message-ID: <CAHp75Vesp7KrYvQrNXK=fGOH5y+jk9AMHVJkGyu8o+72F9LSrg@mail.gmail.com>
Subject: Re: [PATCH] irq_domain: Standardise legacy/linear domain selection
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        mathias.nyman@linux.intel.com, mika.westerberg@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 2:19 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> A large proportion of interrupt controllers that support legacy mappings
> do so because non-DT systems need to use fixed IRQ numbers when registering
> devices via buses but can otherwise use a linear mapping. The interrupt
> controller itself typically is not affected by the mapping used and best
> practice is to use a linear mapping where possible so drivers frequently
> select at runtime depending on if a legacy range has been allocated to
> them.
>
> Standardise this behaviour by providing irq_domain_register_simple() which
> will allocate a linear mapping unless a positive first_irq is provided in
> which case it will fall back to a legacy mapping. This helps make best
> practice for irq_domain adoption clearer.

We have a hardware which doesn't support ACPI nor DT. We had got a nice
issue with irq domains after the gpio driver has been moved to the
linear scheme.
Our internal discussion is roughly about misdesigned irq domains
concept for that
kind of hardware. In generic case we could have more than one PIC, and more than
one hardware that requires real 1:1 mapping of the irq numbers, and
kernel doesn't
know about the last mapping until real driver module is loaded (for
example a PCI
controller of something).

The issue is in plain array of the numbers that are assigned to the devices.
Somehow looks better to have real namespaces, or even hide irq number in the API
struct device, request_irq(), but keep reference between driver and PIC via some
object.

So, given solution just hides an issue, but doesn't resolve it fully
from my p.o.v.

-- 
With Best Regards,
Andy Shevchenko
