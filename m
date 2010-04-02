Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759113Ab0DBCuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 22:50:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35643 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759015Ab0DBCuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 22:50:06 -0400
X-Authority-Analysis: v=1.1 cv=8Rq9yliVGc3GxcN10kx+g7e/eWPAtZnInWtRlahw0rA= c=1 sm=0 a=j_jVqYyEI08A:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=meVymXHHAAAA:8 a=MfxSxOU0lvse6fzeu8gA:9 a=V5ZXaFo2GyoS05Kj8soVuRDQJDUA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 1/2 v4] scsi: add __print_hex() to ftrace
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       James Bottomley <James.Bottomley@suse.de>,
       Ingo Molnar <mingo@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
In-Reply-To: <4BB55935.9040100@cn.fujitsu.com>
References: <4BB4855E.7030509@jp.fujitsu.com>
	 <4BB4864A.3060406@jp.fujitsu.com>
	 <1270130265.19685.8933.camel@gandalf.stny.rr.com>
	 <4BB55935.9040100@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 01 Apr 2010 22:50:03 -0400
Message-ID: <1270176603.19685.9721.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-02 at 10:40 +0800, Li Zefan wrote:
> >> +const char *
> >> +ftrace_print_hex_seq(struct trace_seq *p, const unsigned char *buf, int buf_len)
> >> +{
> >> +	int i;
> >> +	const char *ret = p->buffer + p->len;
> >> +
> >> +	for (i = 0; i < buf_len; i++)
> >> +		trace_seq_printf(p, "%s%2.2x", i == 0 ? "" : " ", buf[i]);
> >> +
> >> +	trace_seq_putc(p, 0);
> > 
> > I would not put the putc(p, 0) into a helper function. This terminates
> > the buffer, and strings added to the trace_seq will go after the '\0'.
> > 
> 
> This is exactly what ftrace_print_flags_seq() and ftrace_print_symbols_seq()
> do, and exactly what we want.
> 
> An example:
> 
> TP_printk("%s,%s", __print_flags(...), __print_flags(...));
> 
> We need 2 seperated strings, while trace_seq_terminate() will make it
> a single string.

You're right! But I still don't like it ;-)

I probably should have had that in the __print_flags() macro instead of
the function. Oh well. These are only helper functions for the
__print*() variants anyway.

OK, you can have my Acked-by: Steven Rostedt <rostedt@goodmis.org> for
this.

-- Steve


