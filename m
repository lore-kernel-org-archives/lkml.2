Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab0LGWt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 17:49:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48942 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab0LGWt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 17:49:57 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=WT7wE6qrmEcA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=drwWOgwSlDPRpsh2tVYA:9 a=pS7IGazhiC3bCg28GpUA:7 a=BtmUsKObgDSemaN21B_QZT32nD0A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 3/8] Add yaffs2 file system: guts code
From: Steven Rostedt <rostedt@goodmis.org>
To: Charles Manning <manningc2@actrix.gen.nz>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        "Theodore Ts'o" <tytso@mit.edu>
In-Reply-To: <201012080943.48938.manningc2@actrix.gen.nz>
References: <1291154254-22533-1-git-send-email-cdhmanning@gmail.com>
	 <201012071712.12772.manningc2@actrix.gen.nz>
	 <1291733370.16223.242.camel@gandalf.stny.rr.com>
	 <201012080943.48938.manningc2@actrix.gen.nz>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 07 Dec 2010 17:49:54 -0500
Message-ID: <1291762194.5015.5.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 09:43 +1300, Charles Manning wrote:

> > Adding the TRACE_EVENT() code is also simple too ;)
> 
> For 500 traces?

Are all of them for the BUFFER code?

> 
> Please remember that yaffs is typically used in embedded systems - not big 
> iron servers . Typical kernel sizes are between 1 and 3MB. Pretty much all 
> the big iron features get turned off.

OK then what about just using printk(KERN_DEBUG, ...)


> Yaffs is used in embedded systems (eg. phones). There is no operator. The only 
> people that ever look at dmesg and the log are engineers during 
> integration/testing.

OK, then use pr_debug(), these can even be compiled out of the kernel
for production.


> 
> > There's also levels of printks that you 
> > can do:
> >
> > KERN_ERR, KERN_WARING, KERN_INFO, KERN_DEBUG, etc.
> >
> > But again, these go to the users console and into the message logs.
> > If 
> > it is something that is a high activity this can slow down the system as
> > printk's are synchronous. That is, they don't continue work until they
> > finished writing. If you have a serial console, that could really slow
> > things down.
> 
> That is exactly why I use the bitmasks to be able to be able to select sets of 
> messages to be enabled. [btw: Enabling sets of traces seems to be a feature 
> that TRACE_EVENT() lacks, or perhaps I have not read enough].

You can group trace_events into TRACE_SYSTEMS, and then enable a bunch
of events under which system they are in. I thought about making this
into a hierarchy, but have yet seen the true need for that.


> 
> The trace mask allows you to set up a test case very easily and delivers the 
> output where it is readily available.
> 
> >
> > printk's should not be used for real debugging anyway. But putting it
> > into a tracepoint, then it opens up lots of options.
> >
> > Your T(YAFFS_TRACE_ALWAYS, ...) look like good candidates for printks.
> >
> > TRACE_EVENTS() are those that just want to analyze what is happening in
> > the system.
> 
> All, well almost all, embedded systems have printk. Many don't have TRACE.
> 
> People using yaffs do not want to lose what they already have and like the way 
> tracing is set up.
> 
> What I propose is just rewriting the current trace mechanism so the code looks 
> cleaner.

Fine, as it seems special purpose for embedded devices.

-- Steve


