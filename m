Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793Ab1CZWhl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 18:37:41 -0400
Received: from smtp-out.google.com ([216.239.44.51]:18724 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab1CZWhj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 18:37:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=moKUJKvoX09PuZwlNuJwYwkr5mt5E6mexHShOZS3lwVUm2OQT8XXSSKsW039dsyDzn
         Lu5ne+opKZYn1/wbwAbA==
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1103262118010.31464@localhost6.localdomain6>
References: <20110325131617.258789658@linutronix.de>
	<20110325132047.552074703@linutronix.de>
	<4D8E4897.5030705@nvidia.com>
	<alpine.LFD.2.00.1103262118010.31464@localhost6.localdomain6>
Date: Sat, 26 Mar 2011 15:37:34 -0700
X-Google-Sender-Auth: 7vjqGlyIe2D663LbZjd3RPbeV9A
Message-ID: <AANLkTi=y9JkpJVCq5G151G9k3d0rAcSH13gi6uGB_gDX@mail.gmail.com>
Subject: Re: [patch 02/23] arm: tegra: Remove unused function which fiddles
 with irq_desc
From: Colin Cross <ccross@android.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Varun Wadekar <vwadekar@nvidia.com>, LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 26, 2011 at 1:24 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Sun, 27 Mar 2011, Varun Wadekar wrote:
>>
>> Thomas, then how do you think we should handle restoring of gpio states
>> across suspend-resume cycles?
>
> That code is unused. Period. No caller, nothing nada. So what does it
> handle?

Tegra suspend support didn't make it into 2.6.39, but should get
merged in 2.6.40, and will call tegra_gpio_suspend/resume.

>> > -
>> > -   for (i = INT_GPIO_BASE; i < (INT_GPIO_BASE + TEGRA_NR_GPIOS); i++) {
>> > -           struct irq_desc *desc = irq_to_desc(i);
>> > -           if (!desc || (desc->status & IRQ_WAKEUP))
>> > -                   continue;
>> > -           enable_irq(i);
>> > -   }
>
> And this part is totally unacceptable and should have never been
> merged. Further it is in the way of cleanups to the core code and as
> there is no user I'm not willing to even think about what it does and
> why it is there.
>
> FYI, the core code deals with interrupt suspending/resuming
> already. So if there is a problem with that which does not cover your
> specific problem, then you better talk to me before hacking up such
> private workarounds and expecting that I tolerate them in unused code.

Yes, the existing code wrong, and unnecessary.  It was copied from
mach-tegra/irq.c, which I later fixed, but I missed this one.  I'll
take this patch for 2.6.39-rc1, which will prevent merge conflicts
between your tree and the tegra tree in 2.6.40.
