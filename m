Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab0CYNiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 09:38:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64974 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab0CYNiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 09:38:12 -0400
X-Authority-Analysis: v=1.1 cv=wckZLekju2+u3kt9osT+oU4XGSlOYx61urhSnO42l8s= c=1 sm=0 a=K3bVECq4cSYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=U7UbAiMzAAAA:8 a=wQL7BEUty7H-OHpifzMA:9 a=W2a0zEwdf3FmpUM18bEA:7 a=58Z8KwHXB4COEoJ2aMLKedwa368A:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] trace: reorder struct ring_buffer_per_cpu to remove
 padding on 64bit
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>
In-Reply-To: <1269516456.2054.8.camel@localhost>
References: <1269516456.2054.8.camel@localhost>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 25 Mar 2010 09:38:10 -0400
Message-ID: <1269524290.2957.4073.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-25 at 11:27 +0000, Richard Kennedy wrote:
> Reorder structure to remove 8 bytes of padding on 64 bit builds.
> This shrinks the size to 128 bytes so allowing allocation from a smaller
> slab & needed one fewer cache lines.
> 

Thanks!

Just curious, did you use Arnaldo's pahole utility to find this?

-- Steve

> Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
> ----
> patch against 2.6.34-rc2
> compiled & booted on x86_64
> 
> regards
> Richard
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 05a9f83..421db5e 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -422,6 +422,7 @@ int ring_buffer_print_page_header(struct trace_seq
> *s)
>   */
>  struct ring_buffer_per_cpu {
>  	int				cpu;
> +	atomic_t			record_disabled;
>  	struct ring_buffer		*buffer;
>  	spinlock_t			reader_lock;	/* serialize readers */
>  	arch_spinlock_t			lock;
> @@ -439,7 +440,6 @@ struct ring_buffer_per_cpu {
>  	unsigned long			read;
>  	u64				write_stamp;
>  	u64				read_stamp;
> -	atomic_t			record_disabled;
>  };
>  
>  struct ring_buffer {
> 
> 


