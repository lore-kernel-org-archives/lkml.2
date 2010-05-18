Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab0ERUt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 16:49:58 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:50489 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756040Ab0ERUtz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 16:49:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XQe+IZOgYcMa3kWcEsZcbw9spBIBm7xulxTaty4lkSFmL3OyJH/W2+sdqI3YGXdI8X
         ct987u23dWWOmtb/sm5qZ875KfSgmY1hrYgkJMqDosgidkq9oDnMziLTZU6QQM89/MyV
         aK4BalMym+Z4FFGx5KNXFwnMdejTV/zJvrBq0=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1005182143100.3368@localhost.localdomain>
References: <AANLkTimxLHngWamPvWt-htGoZ7Nub72rvJAnmGtw4Eqw@mail.gmail.com>
	 <AANLkTinClrTDoXH4NPP2-SgSYH24ZTnqsop88aocdg4R@mail.gmail.com>
	 <alpine.LFD.2.00.1005182143100.3368@localhost.localdomain>
Date: Tue, 18 May 2010 15:49:54 -0500
Message-ID: <AANLkTiktb6CIP9PsM4pX2Izwrx5bXjXjqoHNqXSdyhJG@mail.gmail.com>
Subject: Re: PREEMPT_RT (2.6.33-rt17) disabled printk-to-console after 
	console_init
From: Xianghua Xiao <xiaoxianghua@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 2:47 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 18 May 2010, Xianghua Xiao wrote:
>> I could not get dmesg output to console/serial and
>> klogd(/var/log/messages) anymore with 2.6.33-rt17 _after_ the kernel
>> boot is done(on non-RT kernel it works fine). I made below changes it
>> starts to work again, however I'm unsure how safe the change is.
>> Please advise.
>
> Well, obviously it's unsafe if you remove safety checks. And if you
> care to look at the changelog of kernel/printk.c you'll find out why.
>
> Short story: It's introducing nasty latencies.
>
> Use "earlyprintk=serial,ttyS0,115200,keep" if you care, but do not
> complain about the resulting latencies.
>
> Thanks,
>
>        tglx
>

The earlyprintk bootargs did not work...

will try http://lkml.org/lkml/2008/1/24/390 to see if helps on latencies.

While latency is key, we also need klogd to work at least(disabling
output to serial console may be fine), without that hack somehow klogd
did not get invoked and we have nothing logged from the kernel onto
storage device.

Thanks again,
Xianghua
