Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab0E1BS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 21:18:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45635 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716Ab0E1BSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 21:18:24 -0400
X-Authority-Analysis: v=1.1 cv=Pm0qIGCwx3bIEOZlSg1a56K3RSwKBTW9sPEb+DFvEKk= c=1 sm=0 a=GQ3jqF8VmdQA:10 a=GQCbJdZ--msA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=07d9gI8wAAAA:8 a=kn3Cvx327aoEqgSqA6UA:9 a=x5WTrr7B1x4H0gtJolmlzR9KZTgA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 1/6] writeback: initial tracing support
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
       linux-ext4@vger.kernel.org, tytso@mit.edu, jens.axboe@oracle.com
In-Reply-To: <20100527143233.836b2c47.akpm@linux-foundation.org>
References: <1274784852-30502-1-git-send-email-david@fromorbit.com>
	 <1274784852-30502-2-git-send-email-david@fromorbit.com>
	 <20100527143233.836b2c47.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 27 May 2010 21:18:21 -0400
Message-ID: <1275009502.22648.582.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 14:32 -0700, Andrew Morton wrote:

> > --- /dev/null
> > +++ b/include/trace/events/writeback.h
> > @@ -0,0 +1,171 @@
> > +#undef TRACE_SYSTEM
> > +#define TRACE_SYSTEM writeback
> > +
> > +#if !defined(_TRACE_WRITEBACK_H) || defined(TRACE_HEADER_MULTI_READ)
> 
> Seems wrong.  If you define TRACE_HEADER_MULTI_READ then include this
> header twice, things explode.  Which negates the purpose of
> _TRACE_WRITEBACK_H.

That's intended. It is documented in
samples/trace_events/trace-events-samples.h

The purpose of the TRACE_HEADER_MULTI_READ is to read the trace header
multi times. ;-)


You can also read about it here:

 http://lwn.net/Articles/379903/

here:

  http://lwn.net/Articles/381064/

and here:

   http://lwn.net/Articles/383362/

-- Steve

> 
> > +#define _TRACE_WRITEBACK_H
> > +
> > +#include <linux/backing-dev.h>
> > +#include <linux/writeback.h>
> > +

