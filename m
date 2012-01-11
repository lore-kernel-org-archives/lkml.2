Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab2AKV1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 16:27:40 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63158 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933997Ab2AKV1V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 16:27:21 -0500
MIME-Version: 1.0
In-Reply-To: <4F0DFC0F.2090005@gmail.com>
References: <1326313337-24603-1-git-send-email-grant.likely@secretlab.ca>
 <1326313337-24603-14-git-send-email-grant.likely@secretlab.ca> <4F0DFC0F.2090005@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 11 Jan 2012 14:27:00 -0700
X-Google-Sender-Auth: iNcnAuozGbhuNF0yhorQrT7B64g
Message-ID: <CACxGe6vVSO0cTgPurr6jFoo9QF_W02UaABOFYadCTQGU9dcwmg@mail.gmail.com>
Subject: Re: [RFC 13/14] irq_domain: Remove 'new' irq_domain in favour of the
 ppc one
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>, sfr@canb.auug.org.au
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 2:15 PM, Rob Herring <robherring2@gmail.com> wrote:
> Grant,
>
> On 01/11/2012 02:22 PM, Grant Likely wrote:
>> This patch removes the simplistic implementation of irq_domains and enables
>> the powerpc infrastructure for all irq_domain users.  The powerpc
>> infrastructure includes support for complex mappings between Linux and
>> hardware irq numbers, and can manage allocation of irq_descs.
>>
>> This patch also converts the few users of irq_domain_add()/irq_domain_del()
>> to call irq_domain_add_legacy() instead.
>
> So what is the non-legacy way? Legacy implies we don't want to do it
> that way. I guess until we remove all non-DT platforms with GIC we are
> stuck with legacy. That seems like it could be a ways out until we get
> there.

Non-legacy is letting the irq_domain manage the irq_desc allocations.
Some of the controllers will be easy to convert, some will be more
difficult.  The primary thing that really blocks getting away from the
legacy method is anything that expects hardcoded #defined irq numbers.
 The goal is to convert all users over to the linear revmap method.

g.
