Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868Ab1CaOdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:33:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:58982 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab1CaOdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:33:32 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=XYJHFtupD_QA:10 a=6MGA-aeKMwUA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=OGtjBijfk6dl5ZB11D4A:9 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Thu, 31 Mar 2011 10:33:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Pavan Savoy <pavan_savoy@sify.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: locks inside receive_buf
Message-ID: <20110331143329.GA14441@home.goodmis.org>
References: <AANLkTi=FrmB=u09wvLoXzQstnV3h-U58R728t3k6_-B-@mail.gmail.com>
 <20110331112559.090948a7@lxorguk.ukuu.org.uk>
 <AANLkTimyVsoRYqoXWYMQz_AN3Uo31NBifmiwDUijWnvS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimyVsoRYqoXWYMQz_AN3Uo31NBifmiwDUijWnvS@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 04:48:29PM +0530, Pavan Savoy wrote:
> 
> Alright, so I see the work gets into the default kthread queue I suppose...?
> However, I am quite puzzled by this kind of OOPS (pasted below...)
> 
> Where I know the TTY called my receive_buf (which is st_tty_receive) -
> which internally calls my parsing function st_int_recv() .....
> I was just wondering, whether it is worth making this internal parsing
> function a tasklet by itself ?
> 
> I kind of do lot of stuff inside the st_int_recv() - including doing a
> tty->ops->write....
> copy in and out of skb queues - So are all this long enough sleeps?
> 
> PC is at st_int_recv+0x2a0/0x354 [st_drv]
> LR is at schedule+0x414/0x4e8

Um, what was the cause of the oops? You did not include that.

-- Steve

> pc : [<bf000fc0>]    lr : [<c04c3ff0>]    psr: 80000013
> sp : efc55ed0  ip : efc55dc0  fp : efc55f0c
> r10: 00000008  r9 : eec4de60  r8 : 00000004
> r7 : 00000000  r6 : 00000007  r5 : ee77bc8f  r4 : ef0f3480
> r3 : 00000000  r2 : 00000000  r1 : 00000020  r0 : 0000001f
> Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> Control: 10c53c7d  Table: af3a004a  DAC: 00000015
> 
> <snip...>
> 
> Backtrace:
> [<bf000d20>] (st_int_recv+0x0/0x354 [st_drv]) from [<bf000170>]
> (st_tty_receive+0x70/0x9c [st_drv])
> [<bf000100>] (st_tty_receive+0x0/0x9c [st_drv]) from [<c02616b4>]
> (flush_to_ldisc+0xfc/0x170)
>  r6:ef10e8f0 r5:ef10e8a4 r4:ef10e800
> [<c02615b8>] (flush_to_ldisc+0x0/0x170) from [<c009bf30>]
> (worker_thread+0x154/0x1e0)
> [<c009bddc>] (worker_thread+0x0/0x1e0) from [<c009fce0>] (kthread+0x84/0x8c)
> [<c009fc5c>] (kthread+0x0/0x8c) from [<c008d6bc>] (do_exit+0x0/0x5f0)
> 
