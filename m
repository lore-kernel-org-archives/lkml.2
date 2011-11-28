Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab1K1QZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 11:25:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823Ab1K1QZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 11:25:09 -0500
Date: Mon, 28 Nov 2011 17:25:01 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] trace: Fix uninitialized variable compiler warning
Message-ID: <20111128162501.GE2201@m.brq.redhat.com>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
 <1322417074-5834-2-git-send-email-jolsa@redhat.com>
 <1322497158.17003.2.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322497158.17003.2.camel@frodo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, Nov 28, 2011 at 11:19:18AM -0500, Steven Rostedt wrote:
> On Sun, 2011-11-27 at 19:04 +0100, Jiri Olsa wrote:
> > Initialize page2 variable to make compiler happy.
> 
> What compiler is this? Because this is a compiler bug. In fact, there's
> no check for page2 being NULL, so if it is used uninitialized it will
> crash the kernel. I don't like these "make the compiler shut up" fixes,
> because honestly, changes like this hide bugs.

[jolsa@krava1 ~]$ gcc --version
gcc (GCC) 4.4.5 20110214 (Red Hat 4.4.5-6)

> 
> Nacked-by: Steven Rostedt <rostedt@goodmis.org>

understood, np

jirka
> 
> -- Steve
> 
> > 
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > ---
> >  kernel/trace/trace.c |    3 +--
> >  1 files changed, 1 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > index 9e158cc..4a06862 100644
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> > @@ -3655,8 +3655,7 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
> >  	struct page *pages[2];
> >  	int nr_pages = 1;
> >  	ssize_t written;
> > -	void *page1;
> > -	void *page2;
> > +	void *page1, *page2 = NULL;
> >  	int offset;
> >  	int size;
> >  	int len;
> 
> 
