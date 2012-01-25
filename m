Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab2AYSvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 13:51:14 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52540 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab2AYSvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 13:51:11 -0500
Message-ID: <4F204F1C.70908@gmail.com>
Date: Wed, 25 Jan 2012 12:51:08 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: "Cousson, Benoit" <b-cousson@ti.com>
CC: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, devicetree-discuss@lists.ozlabs.org,
        Milton Miller <miltonm@bga.com>, benh@kernel.crashing.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [RFCv2 00/14]
References: <1327352870-14687-1-git-send-email-grant.likely@secretlab.ca> <4F1DD6DF.4080706@gmail.com> <4F200DFD.7070407@ti.com>
In-Reply-To: <4F200DFD.7070407@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2012 08:13 AM, Cousson, Benoit wrote:
> On 1/23/2012 10:53 PM, Rob Herring wrote:
>> On 01/23/2012 03:07 PM, Grant Likely wrote:
>>>
>>> Hey everyone,
>>>
>>> Here's the second RFC for the irq_domain patches.  I could use some
>>> help testing now.  I still expect there will be a few bugs.  The
>>> series is based on v3.3-rc1, and I've pushed it out to my git server:
>>>
>>> git://git.secretlab.ca/git/linux-2.6.git irqdomain/next
>>
>> Can you post to linux-arm-kernel too so people are aware of this work
>> and stop posting dead-end irqdomain patches.
> 
> Good point, I have two pending series that are using the
> irq_domain_add() so far, so it will be good to have that branch pulled
> in arm-soc.
> 
>> I tested what you had as of this morning and it works fine for me. Looks
>> like the only diff is the VExpress code. I'm working on rebasing my
>> domain support for generic irqchip now.
> 
> In fact your generic irqchip should even avoid us to use
> irq_domain_add_legacy() since both GPIO and OMAP3 intc are already using
> the irqchip.
> 
> I guess you are not going to change the interface so the patches I did
> on your previous branch to try them should be good already, isn't it?

I've got it rebased on top of Grant's tree. I will send it out soon.

One problem that still remains is it breaks x86 and any platform using
generic irq chip, but not selecting IRQ_DOMAIN. Grant, do you plan to
enable IRQ_DOMAIN for x86 in your series? MIPS may also need fixing.

Rob
