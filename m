Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125Ab0FDCNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 22:13:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64732 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab0FDCNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 22:13:13 -0400
X-Authority-Analysis: v=1.1 cv=xm0otvE9/LjRWYlyDrHfx7zP0/MGCmNk7gQgTP1ehto= c=1 sm=0 a=PrV_ml3jdBcA:10 a=yQWWgrYGNuUA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=nJFUfH9sVRbywR1TkBcA:9 a=EVo11fOrKt8HSDK26bgA:7 a=y3IkeJKY4ymWyS5jgKVHQXdKIXMA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH][GIT PULL][v2.6.35] tracing/events: Convert format
 output to seq_file
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>,
       James Bottomley <James.Bottomley@suse.de>,
       Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
In-Reply-To: <4C0860DE.5020609@cn.fujitsu.com>
References: <1275594103.15884.35.camel@gandalf.stny.rr.com>
	 <4C0860DE.5020609@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 03 Jun 2010 22:13:11 -0400
Message-ID: <1275617591.15884.67.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-04 at 10:11 +0800, Li Zefan wrote:
> > +static void *f_start(struct seq_file *m, loff_t *pos)
> > +{
> > +	loff_t l = 1;
> > +	void *p;
> > +
> > +	/* Start by showing the header */
> > +	if (!*pos) {
> > +		(*pos)++;
> 
> We shoudn't increment *pos in start() handler. It's a common mistake when
> using seqfile. 

And a common mistake I do :-p

I'll rebase it with the fix.

> 
> What we need to do in start() is move the pointer to postion *pos.

So the rest is OK then? All that is needed is the removal of *pos++ ?

Thanks,

-- Steve

> 
> > +		return (void *)FORMAT_HEADER;
> >  	}
> >  
> > -	if (r)
> > -		r = trace_seq_printf(s, "\nprint fmt: %s\n",
> > -				call->print_fmt);
> > +	p = (void *)FORMAT_HEADER;
> > +	do {
> > +		p = f_next(m, p, &l);
> > +	} while (p && l < *pos);
> >  
> > -	if (!r) {
> > -		/*
> > -		 * ug!  The format output is bigger than a PAGE!!
> > -		 */
> > -		buf = "FORMAT TOO BIG\n";
> > -		r = simple_read_from_buffer(ubuf, cnt, ppos,
> > -					      buf, strlen(buf));
> > -		goto out;
> > +	return p;
> > +}


