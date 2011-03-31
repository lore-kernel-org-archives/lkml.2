Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595Ab1CaNr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 09:47:26 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52251 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab1CaNrZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 09:47:25 -0400
MIME-Version: 1.0
In-Reply-To: <20110331132328.GB2202@pengutronix.de>
References: <1301574600-4861-1-git-send-email-monstr@monstr.eu>
 <1301574600-4861-2-git-send-email-monstr@monstr.eu> <20110331124925.GA2202@pengutronix.de>
 <AANLkTi=sG6oVNifwLLi8jjKQXjR6kXZx43NxtFfoPumy@mail.gmail.com> <20110331132328.GB2202@pengutronix.de>
From: John Williams <john.williams@petalogix.com>
Date: Thu, 31 Mar 2011 23:47:04 +1000
Message-ID: <AANLkTikCEYK5K3sQ1rgVK6qMvizQYUn=xsiSPedNRn9A@mail.gmail.com>
Subject: Re: [PATCH] uio/pdrv_genirq: Add OF support
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Michal Simek <monstr@monstr.eu>, devicetree-discuss@lists.ozlabs.org,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        hjk@linutronix.de, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 11:23 PM, Wolfram Sang <w.sang@pengutronix.de> wrote:
>
>>    Maybe I misunderstand you, in my view it is the responsibility of <vendor>
>>    to create their DTS files to indicate they want <special-card1> to bind to
>>    generic-uio.
>
> Device tree is a OS-neutral hardware description language. "generic-uio"
> is neither OS-neutral nor a hardware description. devicetree.org has
> more information about this.

If we are trying to be pure, I might argue we are not changing the DTS
language, but rather just add support in Linux for a particular
use-case.  There is no violation of DTS syntax.

It might be *recommended* that device trees describe only hardware,
although as Michal points out there is already precedent in the
'chosen' node where this is clearly violated, but in a way that is
compatible with DTS syntax.

Is it forbidden to have DTS descriptions of purely virtual devices, as
would be present if you boot a DTS-driven kernel inside a VM
environment, which provides only virtual implementations of various
devices (ethernet etc)?

'vmware,virt-enet' or whatever?

>>    Our use-case is pretty clear, in FPGA-based systems it is common to create
>>    arbitrary devices that developers just want to control from userspace,
>>    with simple IRQ and IO capabilities (DMA can come later :). �They don't
>>    need to bind to other kernel APIs or subsystems, and don't want to invest
>>    in one-off kernel drivers that simply will never go upstream.
>
> For that, the new_compatible-file would be suitable, I think.

# echo "generic-uio" > /sys/class/uio/<something>

?

>>    UIO is perfect, and simply tagging the device as generic-uio in the DTS is
>>    so simple, clean, and elegant.
>
> Simple, yes (I do understand I wrote the first approach ;)) . Elegant,
> not really, because it breaks core conventions of the device tree. For
> your case it is a very conveniant hack, but it is still a hack.

Being useful seems like a high priority in the kernel, I'm not ashamed of it! :)

Regards,

John
