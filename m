Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab0DOPFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 11:05:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57577 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab0DOPFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 11:05:54 -0400
X-Authority-Analysis: v=1.1 cv=wzQuF8Yqs4IO6CYUtTy28yZyBjSHZbbofww7aEg0rsQ= c=1 sm=0 a=IkcTkHD0fZMA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=D19gQVrFAAAA:8 a=PpKaerNTvt2m38JixWMA:9 a=DpBJh3Lxepyrfg9d6BrlnNs7YpgA:4 a=QEXdDO2ut3YA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: sched_clock - microblaze
From: Steven Rostedt <rostedt@goodmis.org>
To: michal.simek@petalogix.com
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Wu Zhangjin <wuzhangjin@gmail.com>
In-Reply-To: <4BC728DD.5020404@petalogix.com>
References: <4BC728DD.5020404@petalogix.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Apr 2010 11:04:48 -0400
Message-ID: <1271343888.1880.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-15 at 16:55 +0200, Michal Simek wrote:
> Hi Thomas and Steven,
> 
> I would like to improve time measuring for ftrace (Log below)
> 
> I looked at http://lkml.org/lkml/2009/11/16/181
> where Thomas suggested to create sched_clock() function.
> I used the same solution as Wu proposed but it is not nice.
> 
> Is unimplemented sched_clock the reason why ftrace not show fine grain time?

Yeah, sched_clock is used by ftrace for timings, so if it only returns
jiffies, then that will, unfortunately, be the resolution of the tracer.

I've been told that if you make a higher resolution timer for sched
clock, it will improve the scheduling in CFS.

-- Steve

> 
> Or is there any other thing which is wrong?
> 
> Thanks,
> Michal
> 
> 
> 
> Dumping ftrace buffer:
> ---------------------------------
>   0) ! 10000.00 us |                                }
>   0)   <========== |
>   0) ! 10000.00 us |                            }
>   0) ! 10000.00 us |                          }
>   0)   0.000 us    |                          get_seconds();
>   0)   0.000 us    |                          tcp_rcv_rtt_update();
>   0)   0.000 us    |                          tcp_ack();
>   0)   0.000 us    |                          tcp_rcv_rtt_update();
>   0)   0.000 us    |                          tcp_urg();
>   0)               |                          tcp_data_queue() {
>   0)   0.000 us    |                            __sk_mem_schedule();
>   0)   0.000 us    |                            tcp_event_data_recv();
>   0)   0.000 us    |                            sock_def_readable();
>   0)   0.000 us    |                          }
>   0)   0.000 us    |                          tcp_check_space();
>   0)               |                          __tcp_ack_snd_check() {
> 
> 


