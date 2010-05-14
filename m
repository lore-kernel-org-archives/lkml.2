Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592Ab0ENMyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 08:54:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36370 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307Ab0ENMyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 08:54:51 -0400
X-Authority-Analysis: v=1.1 cv=MoOeBCR3UCSroT7bBzr0mtJUqJhHyBWzyNa37ex1qNU= c=1 sm=0 a=r5AvUYk336kA:10 a=GQCbJdZ--msA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=UAaJ_etPrk5clunSabcA:9 a=tot16sTQKds_hdlIcowA:7 a=XEM0lg_YM44zYRu4-TC4DzMgMm8A:4 a=PUjeQqilurYA:10 a=NYk95v7EdE2iIOKv:21 a=wybwJCPS-ktWtS4z:21 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 2/7] perf trace: Correctly handle arrays
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ian Munsie <imunsie@au1.ibm.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>
In-Reply-To: <1273833586.1626.244.camel@laptop>
References: <1273730632-21008-1-git-send-email-imunsie@au1.ibm.com>
	 <1273730632-21008-3-git-send-email-imunsie@au1.ibm.com>
	 <1273768374.27703.1101.camel@gandalf.stny.rr.com>
	 <1273833586.1626.244.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 14 May 2010 08:54:47 -0400
Message-ID: <1273841687.27703.2377.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-14 at 12:39 +0200, Peter Zijlstra wrote:
> On Thu, 2010-05-13 at 12:32 -0400, Steven Rostedt wrote:
> > 
> > -- Steve
> > 
> > > +             else
> > > +                     field->elementsize = field->size;
> > > +
> > >               *fields = field;
> > >               fields = &field->next;
> > >  
> > > @@ -2101,7 +2109,8 @@ static unsigned long long eval_num_arg(void *data, int size,
> > >                       }
> > >                       right = eval_num_arg(data, size, event, arg->op.right);
> > >                       val = read_size(data + larg->field.field->offset +
> > > -                                     right * long_size, long_size);
> > > +                                     right * larg->field.field->elementsize,
> > > +                                     larg->field.field->elementsize);
> > >                       break;
> > >               }
> > >   default_op:
> > > diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
> > > index 406d452..cc58a19 100644
> > > --- a/tools/perf/util/trace-event.h
> > > +++ b/tools/perf/util/trace-event.h
> > > @@ -40,6 +40,8 @@ struct format_field {
> > >       char                    *name;
> > >       int                     offset;
> > >       int                     size;
> > > +     unsigned int            arraylen;
> > > +     unsigned int            elementsize;
> > >       unsigned long           flags;
> > >  };
> > >  
> 
> What's with this new fad of not trimming emails?
> 

I usually do, but if it isn't that big I don't. But my rule (and I
suspect it with others too) is that I end my comments with my sig 
(-- Steve). After that, I have no more comments so you do not need to
look further. When I see someone's sig in the mail, I stop reading
further.

-- Steve



