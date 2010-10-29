Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934098Ab0J2P5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 11:57:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36599 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932797Ab0J2P5N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 11:57:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=f3KtWOr5T3SwTjK3dCY2NavVq6NsaX+noO5OVUbFdOHB1oGBagwJ0J0AIok7n8bsuf
         HZjsFmD+MYaaz+c4eH46Pj5ytauoAzMP7qJwyokNtDNQeMC10zaDEsCyG0jUuTRmBJN6
         xcg1jJMJNMr1nKIkoCWFEmHc6KV+/v0rQ3nCQ=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1010291725370.2692@localhost6.localdomain6>
References: <1288288718-1188-1-git-send-email-rabin@rab.in>
	<alpine.LFD.2.00.1010282053180.2692@localhost6.localdomain6>
	<AANLkTinaTTqv3r0tWDOeZR5n=nHj5LybxAPf5uvUxpRh@mail.gmail.com>
	<alpine.LFD.2.00.1010291725370.2692@localhost6.localdomain6>
Date: Fri, 29 Oct 2010 21:27:11 +0530
X-Google-Sender-Auth: rPyIqU8EjOnhTNEjHN4FwrIUPOE
Message-ID: <AANLkTim_XKe9f_Onc9jXiuq14CSk9kPbPLTFvcT9caR7@mail.gmail.com>
Subject: Re: [PATCH] genirq: handle shared irqs in handle_nested_irq()
From: Rabin Vincent <rabin@rab.in>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 8:56 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 29 Oct 2010, Rabin Vincent wrote:
>> On Fri, Oct 29, 2010 at 12:24 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> > On Thu, 28 Oct 2010, Rabin Vincent wrote:
>> >> Allow shared irqs to work when nested threads are used for handling
>> >> threaded interrupts.
>> >
>> > Why do we want this ? handle_nested_irq() is called from a interrupt
>> > demultiplexer, so why would we need shared interrupts for this ?
>>
>> Threaded IRQ + handle_nested_irq() is used by I2C GPIO expander drivers
>> like chained hander + generic_handle_irq() is used by on-chip GPIO
>> drivers.  If two irq handlers are registered on an on-chip GPIO
>> interrupt (because two devices are externally connected), it works.  If
>> the handlers are instead registered on one of the expander's pins'
>> interrupt, without this patch, only the handler registered first is
>> called.
>
> Have the hardware dudes not yet understood that shared interrupts are
> a horrible idea ?

Note that I haven't actually seen the multiple devices to expander GPIO
(yet?, though I've seen the multiple devices to onchip GPIO).  It seemed
to be something missing from the irq handling though, rather than
something that was left out on purpose.

Rabin
