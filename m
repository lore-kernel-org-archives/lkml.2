Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab0LGArs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 19:47:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57316 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab0LGArr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 19:47:47 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=WT7wE6qrmEcA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=-fgAWmIJF59LB52nSrIA:9 a=iNOkuNohefgNfC3k57R-EoCPIKUA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 3/8] Add yaffs2 file system: guts code
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Charles Manning <manningc2@actrix.gen.nz>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <201012070003.42224.arnd@arndb.de>
References: <1291154254-22533-1-git-send-email-cdhmanning@gmail.com>
	 <201012061355.44032.arnd@arndb.de>
	 <201012071113.51408.manningc2@actrix.gen.nz>
	 <201012070003.42224.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 06 Dec 2010 19:47:43 -0500
Message-ID: <1291682864.16223.37.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-07 at 00:03 +0100, Arnd Bergmann wrote:

> > > > yaffs_trace(YAFFS_TRACE_BUFFERS,
> > > > 	"Out of temp buffers at line %d, other held by lines:",line_no);
> > > > for (i = 0; i < YAFFS_N_TEMP_BUFFERS; i++)
> > > > 	yaffs_trace(YAFFS_TRACE_BUFFERS," %d ", dev->temp_buffer[i].line);
> > > > yaffs_trace(YAFFS_TRACE_BUFFERS, "\n");
> > > >
> > > > Would that be OK?
> > > >
> > > > I am loath to have to pull out useful code then plug it back in again.
> > >
> > > I don't think the yaffs_trace() function would be much better than the T()
> > > macro, I was talking more about the fact that you have your own nonstandard
> > > tracing infrastructure than the ugliness of the interface.
> > >
> > > The point of pulling it out now would be force you to rethink the
> > > tracing. If you think that you'd arrive at the same conclusion, just
> > > save the diff between the code with and without tracing so you can
> > > submit that patch again later.
> > >
> > > Having some sort of tracing is clearly useful, but it's also not essential
> > > for the basic yaffs2 operation. We want to keep a consistent way of
> > > presenting trace points across the kernel, so as long as you do it
> > > differently, your code is going to be viewed with some suspicion.
> > >
> > > Please have a look at how ext4, gfs2 and xfs do tracing.
> > 
> > Looking in Linus' tree, all of those contain custom tracing of the form I 
> > propose.
> 
> Hmm, yes I guess that's right...
> 
> I was specifically talking about the include/trace/* based trace events
> as something to look at, not the random printk based tracing stuff.
> Maybe Steven or Frederic can give some more insight on that.
> 

What are all those T() functions? Some look like they should be replaced
with printk(KERN_* "") functions, some others for tracing (I guess the
ones with YAFFS_TRACE_TRACING).

ext4, gfs and xfs all have converted to the TRACE_EVENT() methods. When
you have this, you get tracing for free. The work with both ftrace and
perf. You can look at the samples/trace_events/ code for examples.

Note, if you use TRACE_EVENT() and you want to debug even more, you can
simply add trace_printk() and that will also appear in your tracing
output.

-- Steve


