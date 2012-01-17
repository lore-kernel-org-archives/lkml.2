Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546Ab2AQDnA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 22:43:00 -0500
Received: from gate.crashing.org ([63.228.1.57]:46455 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758Ab2AQDm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 22:42:58 -0500
Message-ID: <1326771731.26116.29.camel@pasglop>
Subject: Re: [RFC 13/14] irq_domain: Remove 'new' irq_domain in favour of
 the ppc one
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Michael Bohan <mbohan@codeaurora.org>
Cc: Rob Herring <robherring2@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>, sfr@canb.auug.org.au,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org
Date: Tue, 17 Jan 2012 14:42:11 +1100
In-Reply-To: <4F14E05C.30207@codeaurora.org>
References: <1326313337-24603-1-git-send-email-grant.likely@secretlab.ca>
	 <1326313337-24603-14-git-send-email-grant.likely@secretlab.ca>
	 <4F0DFC0F.2090005@gmail.com>
	 <CACxGe6vVSO0cTgPurr6jFoo9QF_W02UaABOFYadCTQGU9dcwmg@mail.gmail.com>
	 <4F0F7B60.5040701@gmail.com> <4F14E05C.30207@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-16 at 18:43 -0800, Michael Bohan wrote:
> 
> I was planning on sending these patches out, but it seems like with 
> Grant's patches, they may no longer be up to date. I was curious if any 
> thought was given to supporting configurations like this the one I 
> mentioned with the advent of these patches. I am happy to help test if 
> you can steer me in the right direction.

I haven't had a chance to look in detail at what Grant is doing in his
latest series, but the ppc domain scheme that he's basing it on has the
concept of sparse interrupt domains.

For these, we use a radix tree for the reverse map (we do not rely on a
linear range) and we "allocate" linux IRQ numbers on-demand as we create
mapping for individual HW interrupts.

Cheers,
Ben.


