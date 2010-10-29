Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826Ab0J2PVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 11:21:41 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35699 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932635Ab0J2PVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 11:21:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=iBbL+1DoerahlnGgZI606GnCXOamJExl/Cqo3RKRzSbs0vqJN+ZSbWsZqTOfYrn4Vp
         4b2dT7mcadfFxKsoAm/+wblOi6dLAet2yzlc6Yx+lrvbClnsD33eh4B3ucglK0kIIUvF
         BpFJ3QjVUTa05qLUR2EHNsrKeX+wTDzneDd50=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1010282053180.2692@localhost6.localdomain6>
References: <1288288718-1188-1-git-send-email-rabin@rab.in>
	<alpine.LFD.2.00.1010282053180.2692@localhost6.localdomain6>
Date: Fri, 29 Oct 2010 20:51:38 +0530
X-Google-Sender-Auth: xv2-7aEwtJaHYAhCvcNHpGkMy6s
Message-ID: <AANLkTinaTTqv3r0tWDOeZR5n=nHj5LybxAPf5uvUxpRh@mail.gmail.com>
Subject: Re: [PATCH] genirq: handle shared irqs in handle_nested_irq()
From: Rabin Vincent <rabin@rab.in>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 12:24 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 28 Oct 2010, Rabin Vincent wrote:
>> Allow shared irqs to work when nested threads are used for handling
>> threaded interrupts.
>
> Why do we want this ? handle_nested_irq() is called from a interrupt
> demultiplexer, so why would we need shared interrupts for this ?

Threaded IRQ + handle_nested_irq() is used by I2C GPIO expander drivers
like chained hander + generic_handle_irq() is used by on-chip GPIO
drivers.  If two irq handlers are registered on an on-chip GPIO
interrupt (because two devices are externally connected), it works.  If
the handlers are instead registered on one of the expander's pins'
interrupt, without this patch, only the handler registered first is
called.

Rabin
