Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab2KNA62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 19:58:28 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:54608
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756056Ab2KNA60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 19:58:26 -0500
X-Forefront-Antispam-Report: CIP:160.33.194.231;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail04v.am.sony.com;RD:mail04.sonyusa.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI9371I1432Izz1de0h1202h1d1ah1d2ahzz8275dhz2fh2a8h668h839h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1155h)
Message-ID: <50A2ECDB.7030901@am.sony.com>
Date: Tue, 13 Nov 2012 16:59:07 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Constantine Shulyupin <const@makelinux.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "celinux-dev@lists.celinuxforum.org" 
	<celinux-dev@lists.celinuxforum.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Celinux-dev] [PATCH] LDT - Linux Driver Template
References: <1352832397-1349-1-git-send-email-const@MakeLinux.com> <20121113190123.GA32271@kroah.com> <CAE7jHC_bTi7bNwTyPh=wsstGUFegisDUtt2QvDeAwh94AMoUAQ@mail.gmail.com>
In-Reply-To: <CAE7jHC_bTi7bNwTyPh=wsstGUFegisDUtt2QvDeAwh94AMoUAQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My apologies.  As celinux-dev list administrator, I messed up my
moderation and this response from Greg got discarded instead of
sent to the list.

Here it is, sent by me on Greg's behalf...
 -- Tim

On Wed, Nov 14, 2012 at 02:14:58AM +0200, Constantine Shulyupin wrote:
> On Tue, Nov 13, 2012 at 9:01 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>> +#define pr_debug_hex(h)      pr_debug("%s:%d %s %s = 0x%lX\n", \
>>> +     __file__, __LINE__, __func__, #h, (long int)h)
>>
>> This is not needed at all, just use the proper printk() attribute.
>
> Macro above allows tidy tracing code:
>
>         pr_debug_hex(ioread8(port_ptr + UART_IER));
>         pr_debug_hex(ioread8(port_ptr + UART_IIR));
>         pr_debug_hex(ioread8(port_ptr + UART_FCR));
>         pr_debug_hex(ioread8(port_ptr + UART_LCR));
>         pr_debug_hex(ioread8(port_ptr + UART_MCR));
>         pr_debug_hex(ioread8(port_ptr + UART_LSR));
>         pr_debug_hex(ioread8(port_ptr + UART_MSR));
>
> Without that macro, code above should be rewritten with pr_debug (or printk) as:
>
>         pr_debug("UART_IER=0x%02X\n", ioread8(port_ptr + UART_IER));
>         pr_debug("UART_IIR=0x%02X\n", ioread8(port_ptr + UART_IIR));
>         pr_debug("UART_FCR=0x%02X\n", ioread8(port_ptr + UART_FCR));
>         pr_debug("UART_LCR=0x%02X\n", ioread8(port_ptr + UART_LCR));
>         pr_debug("UART_MCR=0x%02X\n", ioread8(port_ptr + UART_MCR));
>         pr_debug("UART_LSR=0x%02X\n", ioread8(port_ptr + UART_LSR));
>         pr_debug("UART_MSR=0x%02X\n", ioread8(port_ptr + UART_MSR));
>
> That is less readable and less supportable.

What better is to not do foolish stuff like this at all

If you need tracing, use the in-kernel tracing framework, don't roll
your own.

> I prefer the fist case.

I prefer the flower case :)

> Actually I use a lot shorter macro:
> #define traceh(h)   printk("%s = 0x%lX\n", #h, (long int)h)
>
> What is you opinion? Which method is better?

Again, neither, don't clutter your code up with unneeded things like
this.

greg k-h

