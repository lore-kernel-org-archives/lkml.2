Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab0EQOCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 10:02:20 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:63712 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab0EQOCT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 10:02:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bqpvy+vCmmz90vvGdH3DYnyIt8Vgt3NX0AVykFU5mYd0uWG+hWIiJmxRW8f7c1juDO
         xZd4YhxuJn7cdSbiMw94Eav0Lmk5PPIStn7ROrsFKB2K7HKnJUlyvupUy30JqsyhzY7I
         f1zdYcP9eeVp/L77rwHUlygrfmrtqQzDZ8s7k=
MIME-Version: 1.0
In-Reply-To: <AANLkTinFlyz2d4Y6Viw0aWfe6mb6F7Ev4UCvkkQVFADd@mail.gmail.com>
References: <AANLkTin6D2GP0yJJbPYGH1AcAM9-g219rAxSyW_ZlrXV@mail.gmail.com>
	 <AANLkTikjgoBQWqvNxncMUFqWOEXtq4ePvGkvF-m0sGUE@mail.gmail.com>
	 <AANLkTimnlZYonxKzfGHZTV8vwaDptOPHEPBjNhwnV55Y@mail.gmail.com>
	 <1273540344.3843.101.camel@localhost.localdomain>
	 <AANLkTilg2cn3lAIOruz6oZE7V-9uAFDORlbvTX3qxmwF@mail.gmail.com>
	 <AANLkTilb_CGBolyv5Ps9VuhNxFZKtjck4om4G21ICaif@mail.gmail.com>
	 <1273697523.2856.3.camel@localhost.localdomain>
	 <AANLkTinBPDY_WVGaq2LUuOzH0niRpgJ4LEpXWkwBxVqh@mail.gmail.com>
	 <alpine.LFD.2.00.1005170123090.3368@localhost.localdomain>
	 <AANLkTinFlyz2d4Y6Viw0aWfe6mb6F7Ev4UCvkkQVFADd@mail.gmail.com>
Date: Mon, 17 May 2010 10:02:15 -0400
Message-ID: <AANLkTikGwS-Hy_WsymCD1ao0wm0kLIqYEKisYLMf6xs1@mail.gmail.com>
Subject: Re: PROBLEM: tickless scheduling
From: Donald Allen <donaldcallen@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 9:44 AM, Donald Allen <donaldcallen@gmail.com> wrote:
> On Sun, May 16, 2010 at 7:36 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> Donald,
>>
>> On Sat, 15 May 2010, Donald Allen wrote:
>>> Attached. This is from the 2.6.30 kernel on the Arch Linux install cd.
>>>
>>> Here's another bit of data. As I've said previously, the problems I'm
>>> reporting were observed on a Toshiba NB310-305 netbook with a
>>> single-core Atom 450 processor. I just built myself a mini-ITX system
>>> using the Intel D510MO motherboard, which provides a dual-core D510
>>> Atom processor. The other hardware on the board is similar to the
>>> Toshiba. I installed the same Slackware snapshot I used on the
>>> Toshiba, and did the home directory transfer without any problem at
>>> all with the default tickless kernel. The hardware isn't identical,
>>> and while I don't know the internals of the Linux kernel at all, my
>>> gut, backed up by many years of OS development work in scheduling and
>>> memory management, is telling me that the key difference is dual- vs.
>>> single-core. Just a guess.
>>
>> I fear you are wrong.
>
> Please don't be afraid.
>
>>
>> The key difference is almost certainly that the BIOS of your netbook
>> tries to be overly clever vs. power management and is not aware of the
>> fact that the Linux kernel uses timer hardware in a very different way
>> than the other OS which comes preinstalled on that machine.
>>
>> The overly clever BIOS power management which works nicely with the
>> vendor provided "drivers" for the other OS is just interfering with
>> the kernels way of dealing with the problem.
>>
>> Can you please boot with "hpet=disable" on the kernel command line ?
>
> I did, and it made no difference.
>
> To be specific, the test I am doing involves booting with the Arch
> Linux 2009.08 install/live cd. I then run
>
> fsck.ext2 -f -r /dev/sda3
>
> to do a read-only check of my root filesystem. I watch the
> disk-activity light, and it reliably goes out and then you've got a
> long wait if you do nothing. Tickling the touchpad gets things moving
> again. This happens reliably with or without the boot-time option you
> requested above.
>
> I just noticed something else, however, that may lend credence to the
> opinion expressed by Arjan van de Ven that this has nothing to do with
> tickless. I originally noticed this problem on the Toshiba netbook
> when I installed the Slackware 13.1 x86_64 beta on this machine, which
> comes with a tickless 2.6.33.3 kernel. The first symptom I observed
> was attempting to rsync my home directory from another machine to this
> new install and, as previously described, I had to help things along
> by activating the touchpad, or pressing the ctrl key (any kind of
> external stimulus that would generate an interrupt seemed to work).
> Anyway, after some discussion with Patrick Volkerding, I decided to
> build a custom kernel for the netbook and disabled tickless in that
> kernel. After getting that kernel working, I re-did the tests that
> failed with the tickless kernel and they all worked fine, so I thought
> we had our culprit. But just now, after doing the test you requested
> above, I rebooted the system from its installed kernel (the tickful
> kernel I built), and it hung during booting. At first I thought it was
> taking awhile to do the dance with the dhcp server, but after waiting
> longer than I thought this should take, I touched the touchpad and
> forward progress began again immediately (disk light came on, boot
> time chatter proceeded, etc.). So, my current guess, for what it's
> worth, is that there's a race here that causes the system to miss the
> fact that it has a runnable process, and the probability of hitting it
> is reduced, but not to zero, by using tickful scheduling.
>
> I will do the experiment suggested by Arjan van de Ven and report the
> results of that separately.

I just booted with pci=nomsi and the fsck ran normally without any
help from my finger on the touchpad. So I think Arjan is closing in on
this ...

/Don

>
> /Don
>
>
>>
>> Thanks,
>>
>>        tglx
>>
>
