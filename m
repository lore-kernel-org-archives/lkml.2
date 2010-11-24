Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab0KXNqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 08:46:09 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35926 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854Ab0KXNqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 08:46:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=sIlF50de4hU4pyAZRrHL29Rc1Miwx22oTjlYaeIQtagEBObmAqHZf9Q+aRwmcKojd3
         cVfM5RundomCrh3+fMZW94U9JQq3QFYlTOthc+6noWP2M7PqyyyDCCJVKFxicuwBR3uP
         GzKVd2k8oJ0drIV/EyOnHB7szY9lIcIf99V3A=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1011241416360.2900@localhost6.localdomain6>
References: <AANLkTimoBdFyQ6GfS2DKiF0wdRox0x7MfM0_keD9Z1D0@mail.gmail.com>
	<alpine.LFD.2.00.1011241416360.2900@localhost6.localdomain6>
Date: Wed, 24 Nov 2010 21:46:06 +0800
Message-ID: <AANLkTik5N0d9wcaiS538UWQ83E_HhXoWC8nMxVY__1+k@mail.gmail.com>
Subject: Re: [question] NR_IRQS in genirq
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 9:18 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 24 Nov 2010, Haojian Zhuang wrote:
>
>> Hi all,
>>
>> I'm using the latest kernel 2.6.37-rc1. Now I met some issues on genirq.
>>
>> 1. While SPARSE IRQ is enabled, nr_irqs may be larger than NR_IRQS.
>> But the allocated_irqs bitmap (kernel/irq/irqdesc.c) is restricted in
>> NR_IRQS. Is it an issue?
>
> Why can nr_irqs become larger? Is that a theoretical problem or did
> you run into this ?
>
>

Hi Thomas,

My hardware environment is ARM. Each machine description can specify
nr_irqs. In my implementation of PXA, NR_IRQS is fixed for SoC
internal IRQs. And there's some additional board IRQs, we arrange them
between NR_IRQS and nr_irqs. So nr_irqs will be larger than NR_IRQS if
board IRQs exists.

We use dynamic board IRQs since each machine has different
requirement. And CONFIG_HARDIRQ_SW_RESEND is occasionally, I actually
met issue in resend_irqs because of accessing bitmap memory out of
bound.

Do you mean that we shouldn't use SPARSE IRQ by this way?

Best Regards
Haojian
