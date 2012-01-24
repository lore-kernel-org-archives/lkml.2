Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844Ab2AXWLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 17:11:53 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43575 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab2AXWLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 17:11:52 -0500
Message-ID: <4F1F2CA5.1070701@gmail.com>
Date: Tue, 24 Jan 2012 16:11:49 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org, Milton Miller <miltonm@bga.com>,
        benh@kernel.crashing.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFCv2 03/14] irq_domain: Make irq_domain structure match powerpc's
 irq_host
References: <1327352870-14687-1-git-send-email-grant.likely@secretlab.ca> <1327352870-14687-4-git-send-email-grant.likely@secretlab.ca> <4F1F24DD.5030904@gmail.com> <CACxGe6sO-3LHbimBGaWFY98QtK5tiK8uiDodmgO1kVQoi4jDTQ@mail.gmail.com>
In-Reply-To: <CACxGe6sO-3LHbimBGaWFY98QtK5tiK8uiDodmgO1kVQoi4jDTQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2012 04:08 PM, Grant Likely wrote:
> On Tue, Jan 24, 2012 at 2:38 PM, Rob Herring <robherring2@gmail.com> wrote:
>> On 01/23/2012 03:07 PM, Grant Likely wrote:
>>> Part of the series to unify the irq remapping mechanisms in the
>>> kernel.  A follow up patch will copy the powerpc implementation into
>>> kernel/irq/irqdomain.c, which will be a lot easier if the structures
>>> are identical.
>>>
>>> Where they differ, I've chose to use the powerpc names since there is
>>> a lot more code using those names.
>>>
>>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>>> ---
>>>  arch/arm/common/gic.c     |   14 ++++----
>>>  include/linux/irqdomain.h |   84 ++++++++++++++++++++++++++++++++++-----------
>>>  kernel/irq/irqdomain.c    |   14 ++++----
>>>  3 files changed, 78 insertions(+), 34 deletions(-)
>>>
>>
>> snip...
>>
>>> @@ -126,7 +126,7 @@ void irq_dispose_mapping(unsigned int irq)
>>>  }
>>>  EXPORT_SYMBOL_GPL(irq_dispose_mapping);
>>>
>>> -int irq_domain_simple_dt_translate(struct irq_domain *d,
>>> +int irq_domain_simple_xlate(struct irq_domain *d,
>>>                           struct device_node *controller,
>>>                           const u32 *intspec, unsigned int intsize,
>>>                           unsigned long *out_hwirq, unsigned int *out_type)
>>
>> This needs a declaration in irqdomain.h (as well as EXPORT?). There
>> could be others as well, but this is the one I'm using for generic irq chip.
> 
> Fine by me.  I'll add that as a follow-on patch since nothing in-tree
> currently depends on that.  It will be in the next version of the
> patch series.  Also, are you okay if I rename it to
> irq_domain_generic_xlate()?  Simple doesn't really describe it well,
> and it can be used for any interrupt controller implementing the
> binding we've settled on as recommended for new device support.
> 

Okay.

Rob
