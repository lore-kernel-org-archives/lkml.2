Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab1FHDL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 23:11:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59330 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab1FHDL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 23:11:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fjgOYlALI4P3tYijxpIvaRWPm2W0YGRcSq0AYsq0NRXHexxgjTnZQGwfxAa1urbC6+
         5QCMK5JlqpiwA89coMa5ilfT5kT3LaWZhEgUa0FBv53/R8TO9Db/QfAODpGi/4BARGmu
         DwoSZCzWYLiVITxlnVZqjgrcpxpu6MkdBFVXQ=
Subject: Re: [PATCH] blktrace: add FLUSH/FUA support
From: Namhyung Kim <namhyung@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
In-Reply-To: <1307488812.9218.17.camel@gandalf.stny.rr.com>
References: <1306917509-6819-1-git-send-email-namhyung@gmail.com>
	 <1307488812.9218.17.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Jun 2011 12:11:20 +0900
Message-ID: <1307502680.1351.1.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011-06-07 (화), 19:20 -0400, Steven Rostedt:
> On Wed, 2011-06-01 at 17:38 +0900, Namhyung Kim wrote:
> > diff --git a/include/trace/events/block.h b/include/trace/events/block.h
> > index bf366547da25..f21fea24216d 100644
> > --- a/include/trace/events/block.h
> > +++ b/include/trace/events/block.h
> > @@ -19,7 +19,7 @@ DECLARE_EVENT_CLASS(block_rq_with_error,
> >  		__field(  sector_t,	sector			)
> >  		__field(  unsigned int,	nr_sector		)
> >  		__field(  int,		errors			)
> > -		__array(  char,		rwbs,	6		)
> > +		__array(  char,		rwbs,	8		)
> >  		__dynamic_array( char,	cmd,	blk_cmd_buf_len(rq)	)
> >  	),
> >  
> > @@ -104,7 +104,7 @@ DECLARE_EVENT_CLASS(block_rq,
> >  		__field(  sector_t,	sector			)
> >  		__field(  unsigned int,	nr_sector		)
> >  		__field(  unsigned int,	bytes			)
> > -		__array(  char,		rwbs,	6		)
> > +		__array(  char,		rwbs,	8		)
> >  		__array(  char,         comm,   TASK_COMM_LEN   )
> >  		__dynamic_array( char,	cmd,	blk_cmd_buf_len(rq)	)
> >  	),
> > @@ -183,7 +183,7 @@ TRACE_EVENT(block_bio_bounce,
> >  		__field( dev_t,		dev			)
> >  		__field( sector_t,	sector			)
> >  		__field( unsigned int,	nr_sector		)
> > -		__array( char,		rwbs,	6		)
> > +		__array( char,		rwbs,	8		)
> >  		__array( char,		comm,	TASK_COMM_LEN	)
> >  	),
> >  
> 
> 
> Wouldn't it be better to replace all these "6" and "8"'s with a macro?
> Then it would be a heck of a lot easier to change in the future.
> 
> -- Steve
> 
> 

Will fix in the next version, Thanks.


-- 
Regards,
Namhyung Kim


