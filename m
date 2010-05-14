Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab0ENKjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 06:39:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50653 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab0ENKju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 06:39:50 -0400
Subject: Re: [PATCH 2/7] perf trace: Correctly handle arrays
From: Peter Zijlstra <peterz@infradead.org>
To: rostedt@goodmis.org
Cc: Ian Munsie <imunsie@au1.ibm.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>
In-Reply-To: <1273768374.27703.1101.camel@gandalf.stny.rr.com>
References: <1273730632-21008-1-git-send-email-imunsie@au1.ibm.com>
	 <1273730632-21008-3-git-send-email-imunsie@au1.ibm.com>
	 <1273768374.27703.1101.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 12:39:46 +0200
Message-ID: <1273833586.1626.244.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 12:32 -0400, Steven Rostedt wrote:
> 
> -- Steve
> 
> > +             else
> > +                     field->elementsize = field->size;
> > +
> >               *fields = field;
> >               fields = &field->next;
> >  
> > @@ -2101,7 +2109,8 @@ static unsigned long long eval_num_arg(void *data, int size,
> >                       }
> >                       right = eval_num_arg(data, size, event, arg->op.right);
> >                       val = read_size(data + larg->field.field->offset +
> > -                                     right * long_size, long_size);
> > +                                     right * larg->field.field->elementsize,
> > +                                     larg->field.field->elementsize);
> >                       break;
> >               }
> >   default_op:
> > diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
> > index 406d452..cc58a19 100644
> > --- a/tools/perf/util/trace-event.h
> > +++ b/tools/perf/util/trace-event.h
> > @@ -40,6 +40,8 @@ struct format_field {
> >       char                    *name;
> >       int                     offset;
> >       int                     size;
> > +     unsigned int            arraylen;
> > +     unsigned int            elementsize;
> >       unsigned long           flags;
> >  };
> >  

What's with this new fad of not trimming emails?

