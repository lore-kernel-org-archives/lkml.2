Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab0JDSGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 14:06:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:56691 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756312Ab0JDSGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 14:06:04 -0400
X-Authority-Analysis: v=1.1 cv=vbQZhf6WRU4XF+4tPWNJEMYU0N1CowIjcRZ/qR/IBDs= c=1 sm=0 a=YGL2JzEyuHAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=m0bHr2FCAAAA:8 a=Bhn4MsX01p6lHTWtHNAA:9 a=nOf8ap5cqWRMM9gcg7AA:7 a=dlTi2a-qfZwgjI9CCO_U17Vmlq8A:4 a=PUjeQqilurYA:10 a=1JvJEtVdGvUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Dynamic nop selection breaks boot on Geode LX
From: Steven Rostedt <rostedt@goodmis.org>
To: Daniel Drake <dsd@laptop.org>
Cc: Borislav Petkov <bp@alien8.de>, jbaron@redhat.com,
        Andres Salomon <dilinger@queued.net>, Chris Ball <cjb@laptop.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTikhJ6sE=CZ9HytG0p9DN9A0D+kqYB-sP8EfBN85@mail.gmail.com>
References: <AANLkTimF2tcksBkww50MhiO0YY=MCt4rcnfDR+tJhTUJ@mail.gmail.com>
	 <20101003055013.GB25397@liondog.tnic>
	 <AANLkTikhJ6sE=CZ9HytG0p9DN9A0D+kqYB-sP8EfBN85@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 04 Oct 2010 14:06:00 -0400
Message-ID: <1286215560.6750.64.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-10-03 at 17:32 +0100, Daniel Drake wrote:
> On 3 October 2010 06:50, Borislav Petkov <bp@alien8.de> wrote:
> > maybe because the Geode doesn't have both the
> > P6_NOP5 and the NOP with 4 0x66 prefixes:
> > http://kerneltrap.org/mailarchive/linux-kernel/2010/8/27/4612336
> >
> > and for some reason the trap can't find the fixup address. You say
> > "hangs" so you don't even get an "invalid opcode" OOPS?
> 
> The XO doesn't have standard VGA, so it is difficult to debug such
> early crashes. This is crashing so early that kernel messages don't
> even start to get sent over serial.
> 
> To debug these things, I checkpoint the code with various calls which
> send individual characters over serial:
> 
> static void log_serial(char c)
> {
>    while ((inb(0x3fd) & 0x20) == 0) ;
>    outb(c, 0x3f8);
>    while ((inb(0x3fd) & 0x40) == 0) ;
> }

Did you try earlyprintk? That is, on the kernel command line add:

	earlyprintk=ttyS0,115200

or whatever the tty and baud rate is. This will start printing out the
serial right at kernel startup. Even before printk is configured.

-- Steve

> 
> So, I'm not really sure if/how it crashed or oops'd. However, I can
> confirm that panic() does not get reached, since I put a character log
> in there and it doesn't get sent. Let me know if you want me to put
> character logging in other places.
> 
> I applied your two patches by hand and it doesn't solve the issue,
> because the init_amd_k6() code is called long after
> arch_init_ideal_nop5()
> 


