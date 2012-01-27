Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab2A0WNX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 17:13:23 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54340 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab2A0WNW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 17:13:22 -0500
MIME-Version: 1.0
In-Reply-To: <1327702113.24487.19.camel@pasglop>
References: <1327352870-14687-1-git-send-email-grant.likely@secretlab.ca>
 <4F1DD6DF.4080706@gmail.com> <4F200DFD.7070407@ti.com> <4F204F1C.70908@gmail.com>
 <CACxGe6vA6CSCAU82uuMaycqDBt+JG3KvXzAURDWQ0Deyeg13Ow@mail.gmail.com> <1327702113.24487.19.camel@pasglop>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 27 Jan 2012 15:13:02 -0700
X-Google-Sender-Auth: j3X0T1l-I5_OPEJyYdztxYtFr20
Message-ID: <CACxGe6v2AuUrQu1xdfJkmXk05uHm2SgR3LD0_qTNRfvu-YxH1w@mail.gmail.com>
Subject: Re: [RFCv2 00/14]
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rob Herring <robherring2@gmail.com>, "Cousson, Benoit" <b-cousson@ti.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org, Milton Miller <miltonm@bga.com>,
        Shawn Guo <shawn.guo@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 3:08 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Thu, 2012-01-26 at 14:33 -0700, Grant Likely wrote:
>
>> I've got the x86 fix in my tree now.  It will be part of the next
>> merge.  MIPS, Microblaze and OpenRISC cannot turn on CONFIG_IRQ_DOMAIN
>> without rework.  I just hacked together the microblaze version, but
>> Michal will have to verify that it is correct.  I just posted it.  It
>> will be similar for the other two.
>>
>> The real problem is sparc which does something entirely different for
>> irqs.  Rather than resolving irqs on-demand, it calculates the Linux
>> irq numbers at boot time for every node in the tree.  The irq_domains
>> will need to be set up for all interrupt controllers before sparc
>> begins it's big walk of the tree to resolve interrupts.  I haven't dug
>> into everything that needs to be done to support this.
>>
>> I don't think you can count on turning on IRQ_DOMAIN on all
>> architectures just yet.  Adding irq_domain support directly to
>> irq_generic_chip is going to be difficult for that reason.  However,
>> it would be useful to have an irq_domain+irq_generic_chip wrapper that
>> can be enabled only when IRQ_DOMAIN is enabled.
>
> Beware also that there are plenty of cases where 1 irq domain != 1 irq
> chip, for example on cell or xics where a single domain can encompass
> multiple chips. I don't know whether x86 APICs are the same, they could
> be tho :-)

Right, there will be some controllers using multiple irq_generic_chip
instances for a single irq_domain.  Anything with banks of irq
registers is a candidate here.

g.
