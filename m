Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab2FKFCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 01:02:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37120 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab2FKFCh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 01:02:37 -0400
MIME-Version: 1.0
In-Reply-To: <20120611032547.GB10170@linux-sh.org>
References: <1337576792-5347-1-git-send-email-lethal@linux-sh.org>
 <1337576792-5347-2-git-send-email-lethal@linux-sh.org> <20120526015049.1616D3E2336@localhost>
 <20120611032547.GB10170@linux-sh.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 10 Jun 2012 23:02:16 -0600
X-Google-Sender-Auth: X9zmMXBSVZSvsGa-JsLG9GK76cI
Message-ID: <CACxGe6sRVk3sef0X9Q_FDcMx5=y0mKJ-pUM-S2-CitUFQ7koGA@mail.gmail.com>
Subject: Re: [PATCH 2/2] irqdomain: Support for static IRQ mapping and association.
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2012 at 9:25 PM, Paul Mundt <lethal@linux-sh.org> wrote:
> On Fri, May 25, 2012 at 07:50:49PM -0600, Grant Likely wrote:
>> On Mon, 21 May 2012 14:06:32 +0900, Paul Mundt <lethal@linux-sh.org> wrote:
>> > +int irq_create_strict_mappings(struct irq_domain *domain, unsigned int irq_base,
>> > +                          irq_hw_number_t hwirq_base, int count)
>> > +{
>> > +   int ret;
>> > +
>> > +   ret = irq_alloc_descs(irq_base, irq_base, count,
>> > +                         of_node_to_nid(domain->of_node));
>> > +   if (unlikely(ret < 0))
>> > +           return ret;
>> > +
>> > +   ret = irq_domain_associate_many(domain, irq_base, hwirq_base, count);
>> > +   if (unlikely(ret < 0)) {
>> > +           irq_free_descs(irq_base, count);
>> > +           return ret;
>> > +   }
>>
>> It would be really good to make sure the hwirqs aren't already
>> associated before trying to associate them again.  Unfortunately that
>> can't be done (nicely) until I get rid of the slow path lookup.  I've
>> got a patch for that which I'll rebase on top of this one and post soon.
>>
> Any updates on this? I have quite a few more changes I intend on making,
> but there's no point in starting in on that until these existing patches
> are sorted out.

Yeah, I made some progress and have a whole bunch of patches to post
which I had hoped to do last week.  Unfortunately the move to the UK
has meant that the last 7 days have been non-stop cleaning, packing
and throwing out stuff.  I've not been able to do a final cleanup.
The house gets cleaned on Tuesday so it can go on the market on
Wednesday which means all the house stuff must be done by Monday
evening.  Hopefully I'll get some time on Tuesday to do some hacking.

If you want to look at them I've pushed them out to the irqdomain/test
branch on git.secretlab.ca.

g.
