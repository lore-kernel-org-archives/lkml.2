Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab1HJOha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 10:37:30 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59806 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab1HJOh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 10:37:29 -0400
Message-ID: <4E4297A6.6050101@gmail.com>
Date: Wed, 10 Aug 2011 09:37:26 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Mark Rutland <Mark.Rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "weizeng.he@csr.com" <weizeng.he@csr.com>,
        "workgroup.linux@csr.com" <workgroup.linux@csr.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Barry Song'" <21cnbao@gmail.com>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Olof Johansson'" <olof@lixom.net>
Subject: Re: Subject: L2x0 OF properties do not include interrupt #
References: <000201cc575b$c1229010$4367b030$@rutland@arm.com> <4E428EB0.1080204@gmail.com> <20110810141048.GK10121@e102144-lin.cambridge.arm.com>
In-Reply-To: <20110810141048.GK10121@e102144-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2011 09:10 AM, Will Deacon wrote:
> Hi Rob,
> 
> On Wed, Aug 10, 2011 at 02:59:12PM +0100, Rob Herring wrote:
>> I think you should allow for either the single irq or individual irqs.
>> You can specify that the event counter interrupt must be first, then the
>> pmu driver could work either way ignoring the rest. The driver probably
>> needs to mark the handler as shared if there is only the combined
>> interrupt unless you expect all interrupts to be handled by 1 driver.
> 
> I much prefer having seperate, individual IRQs with no requirement on
> ordering.
> 
> Now, the L2 binding also doesn't fit too well for the L2CC on Cortex-A15,
> which is an inner cache like the one on Cortex-A8. Because of this, it
> doesn't have a base address but it *does* have an IRQ which is how external
> aborts are raised.

This is not a general L2 binding, but an L2x0/PL310 binding. A8/A15 L2
is a completely different binding and driver though. You would do
something like the current cpu pmu binding that is just interrupts.

Rob
