Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab0IAANY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 20:13:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:53794 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab0IAANW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 20:13:22 -0400
X-Authority-Analysis: v=1.1 cv=jsU1gHzFqI0vjyg35dbbhFRlpVAv39iqdMS5PbCl9Js= c=1 sm=0 a=jgjcqcETl78A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=YBCthjwFLGtRAjRSnzwA:9 a=s7LJ5Ijo7YJSsOmIHC7VHdOIeYYA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC PATCH 4/9] mce: Add persistent events
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@amd64.org>, acme@infradead.org, fweisbec@gmail.com,
        mingo@elte.hu, linux-kernel@vger.kernel.org,
        Borislav Petkov <borislav.petkov@amd.com>
In-Reply-To: <1281106636.1947.710.camel@laptop>
References: <1281104713-23141-1-git-send-email-bp@amd64.org>
	 <1281104713-23141-5-git-send-email-bp@amd64.org>
	 <1281106636.1947.710.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 31 Aug 2010 20:13:20 -0400
Message-ID: <1283300000.1377.863.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-06 at 16:57 +0200, Peter Zijlstra wrote:
> On Fri, 2010-08-06 at 16:25 +0200, Borislav Petkov wrote:
> > +static const struct file_operations perf_mce_fops = {
> > +       .llseek         = no_llseek,
> > +       .open           = mce_perf_open,
> > +       .poll           = perf_poll,
> > +       .unlocked_ioctl = perf_ioctl,
> > +       .compat_ioctl   = perf_ioctl,
> > +       .mmap           = perf_mmap,
> > +       .fasync         = perf_fasync,
> > +       .release        = perf_release,
> > +}; 
> 
> I'd rather see this part of the persistent bits live in
> kernel/perf_event.c, that way you don't need the previous patch either.
> 

This is part of what I hate about the perf design. The fact that
everything needs to be very coupled. I would like the infrastructure to
be more flexible.

If this does not work, we should have a better internal API that lets
this be done. Otherwise we will have this mce fops in core code that has
no business being there.

-- Steve


