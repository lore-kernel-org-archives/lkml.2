Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971Ab2K0AYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 19:24:18 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:54362 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440Ab2K0AYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 19:24:16 -0500
Message-ID: <50B4082C.5000104@gmail.com>
Date: Mon, 26 Nov 2012 18:24:12 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Anmar Oueja <anmar.oueja@linaro.org>, Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 2/4 v2] irqdomain: augment add_simple() to allocate descs
References: <1349076922-25874-1-git-send-email-linus.walleij@stericsson.com> <20121126202601.625213E0A04@localhost> <CACRpkdZo92OvNmBkqBYU+HgmtR5dmF5vFTaOYPdWr8rtZ3XT_g@mail.gmail.com>
In-Reply-To: <CACRpkdZo92OvNmBkqBYU+HgmtR5dmF5vFTaOYPdWr8rtZ3XT_g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2012 06:13 PM, Linus Walleij wrote:
> On Mon, Nov 26, 2012 at 9:26 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> 
>>> +                     if (irq_base < 0) {
>>> +                             WARN(1, "Cannot allocate irq_descs @ IRQ%d, assuming pre-allocated\n",
>>> +                                  first_irq);
>>> +                             irq_base = first_irq;
>>
>> As I just commented on the previous version, WARN() is probably too
>> verbose (and scary). Make it an informational.
> 
> So the discussion began with me removing exactly that kind of WARN()
> from arch/arm/common/gic.c:
> http://marc.info/?l=linux-arm-kernel&m=134860088710574&w=2
> 
> Which was NACKed by Rob:
> http://marc.info/?l=linux-arm-kernel&m=134860136515611&w=2
> Who prefered to leave it in to encourage platforms to get fixed.
> 
> This code just follows exactly that pattern.
> 
> I'm happy to patch out *both* (or rather patch gic.c to use
> irq_domain_add_simple()) because I never quite liked
> it in the first place.
> 
>> However, I see another problem. What is the requested range straddles
>> the boundary between reserved and non-reserved IRQs? It would be good to
>> give some information about which irq range was requested and maybe
>> report which ones were available.... or check to see if the request is
>> inside or partially inside the reserved region?
> 
> Right now the usual symptom of that is that the system hangs.
> 
> Do you mean we should probe around a bit with
> irq_get_next_irq() to figure out more precisely what the
> problem is, or did you have something more elegant
> in mind?

My objection was removing completely (which a pr_debug effectively
does). I think Grant is saying just make the warning more informative
about why it failed which is fine with me. nr_irqs is already printed
out, so that provides some info already (although it is pretty terse).

Rob
