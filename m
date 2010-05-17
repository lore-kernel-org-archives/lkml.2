Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab0EQOpT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 10:45:19 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:57307 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab0EQOpQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 10:45:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vjI1HGOOJcZDvjqiYSrDKRSUWjN++la2bYNfv3WtJM/mTPWOBoqsnAOU1ftOqJwPze
         y+1p/BlzEyLgQ8zxQga98VPFvlyR4oY4c6UZ3L2PO8FExwjYuLXjQghdn+HbJB634Etx
         jLulOwJlThkxXoznZovPDP1wb4LlpHO5NREsI=
MIME-Version: 1.0
In-Reply-To: <20100517072953.64257f62@infradead.org>
References: <AANLkTin6D2GP0yJJbPYGH1AcAM9-g219rAxSyW_ZlrXV@mail.gmail.com>
	 <AANLkTilg2cn3lAIOruz6oZE7V-9uAFDORlbvTX3qxmwF@mail.gmail.com>
	 <AANLkTilb_CGBolyv5Ps9VuhNxFZKtjck4om4G21ICaif@mail.gmail.com>
	 <1273697523.2856.3.camel@localhost.localdomain>
	 <AANLkTinBPDY_WVGaq2LUuOzH0niRpgJ4LEpXWkwBxVqh@mail.gmail.com>
	 <alpine.LFD.2.00.1005170123090.3368@localhost.localdomain>
	 <AANLkTinFlyz2d4Y6Viw0aWfe6mb6F7Ev4UCvkkQVFADd@mail.gmail.com>
	 <20100517070440.13d193aa@infradead.org>
	 <AANLkTin3tcYAsXVVEdhfPG0YJRYO6gcO-gCl1rlf6XNG@mail.gmail.com>
	 <20100517072953.64257f62@infradead.org>
Date: Mon, 17 May 2010 10:45:13 -0400
Message-ID: <AANLkTinnRmY_00AwxOcqKp1DUtdYf8A7DnjodQ5hiaWd@mail.gmail.com>
Subject: Re: PROBLEM: tickless scheduling
From: Donald Allen <donaldcallen@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 10:29 AM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Mon, 17 May 2010 10:11:51 -0400
> Donald Allen <donaldcallen@gmail.com> wrote:
>
>> On Mon, May 17, 2010 at 10:04 AM, Arjan van de Ven
>> <arjan@infradead.org> wrote:
>> > On Mon, 17 May 2010 09:44:47 -0400
>> > Donald Allen <donaldcallen@gmail.com> wrote:
>> >
>> >> I will do the experiment suggested by Arjan van de Ven and report
>> >> the results of that separately.
>>
>> Just for my own information, is this correct:
>>
>> I assume that tickless scheduling, rather than relying on periodic
>> clock interrupts to wake up the scheduler, relies on interrupt
>> handlers to somehow signal the system that the scheduler needs to run
>> because they've just processed an event that has changed the state of
>> the system?
>
> well.. it relies on the hardware to signal the kernel that there's work
> pending for a specific device.
>
> technically this is true for both tickless and without tickless.
> but without tickless there's so much activity in the system that it
> never really goes quiet (and in fact, some different power management
> decisions may be made because of that)
>
>>
>> If so, then it looks like using the msi-style device-specific
>> interrupts isn't working reliably on this hardware? Or somehow the
>
> that looks like a correct assumption to me.

Thanks for above explanation.

>
>> kernel (or a driver) is failing to handle the interrupts properly with
>> msi enabled on certain hardware? I mention the latter only because of
>> the report yesterday from someone else seeing the same symptoms I am
>> on completely different hardware.
>
> BIOSes breaking MSI is not entirely uncommon. Windows XP does not use
> MSI for various things Linux does use MSI for, and so machines that come
> with XP by default may not have this feature very well tested
> unfortunately.

This machine did come with XP.

I've changed the lilo.config (this is Slackware -- no grub by
default!) to boot by default with pci=nomsi. Tried it once and the
system came up without getting stuck. I will rebuild the kernel with
tickless enabled, since that appears to be a red herring, and will
report results when I have them.

I will also report to Toshiba and the BIOS supplier (Phoenix --
SecureCore v1.40).

/Don

>
>>
>> /Don
>>
>> >
>> >
>> > since you're losing interrupts.. another good option to try is
>> > "irqpoll"
>> >
>> >
>> > --
>> > Arjan van de Ven        Intel Open Source Technology Centre
>> > For development, discussion and tips for power savings,
>> > visit http://www.lesswatts.org
>> >
>
>
> --
> Arjan van de Ven        Intel Open Source Technology Centre
> For development, discussion and tips for power savings,
> visit http://www.lesswatts.org
>
