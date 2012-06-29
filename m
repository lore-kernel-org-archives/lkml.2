Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303Ab2F2Pka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 11:40:30 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:38257 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075Ab2F2PkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 11:40:25 -0400
Date: Fri, 29 Jun 2012 11:40:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Kay Sievers <kay@vrfy.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Wu Fengguang <fengguang.wu@intel.com>, Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH v3] printk: Have printk() never buffer its data
Message-ID: <20120629154020.GA10983@kroah.com>
References: <CAPXgP10cPFSmZ5yr6Z4wVtDa+x2J1yQDF57NJXtxjUuxMHm=Lw@mail.gmail.com>
 <CA+55aFzkX=jCC1O6+2oz8meswOqZQ+Q8Ao60q8eAS1G3AuEStQ@mail.gmail.com>
 <1340726856.977.6.camel@mop>
 <1340810038.16702.16.camel@gandalf.stny.rr.com>
 <1340810283.16702.19.camel@gandalf.stny.rr.com>
 <CAPXgP121+zA_p4x9VdSMWtu-SqqqiNC51CKkYKY4YkAL+QsQ4g@mail.gmail.com>
 <1340869133.876.10.camel@mop>
 <1340852129.16702.73.camel@gandalf.stny.rr.com>
 <20120629053027.GA9841@kroah.com>
 <1340968718.16702.98.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340968718.16702.98.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 07:18:38AM -0400, Steven Rostedt wrote:
> On Fri, 2012-06-29 at 01:30 -0400, Greg Kroah-Hartman wrote:
> >  
> > > I wonder if it would be better to do the following for the above two
> > > ifs:
> > > 
> > > 	if (cont.len && cont.owner == current) {
> > > 		if (!prefix)
> > > 			stored = cont_add(facility, level, text, text_len);
> > > 		cont_flush();
> > > 	}
> > > 
> > > If the prefix was true, then the cont.flush would be set when cont_add()
> > > is called, and the first thing that cont_add() does:
> > > 
> > > 	if (cont.len && cont.flushed)
> > > 		return false;
> > > 
> > > which would always be true (returning false) if prefix was set.
> > > 
> > > And the second cont_flush() is a nop due to it doing:
> > > 
> > > 	if (cont.flushed)
> > > 		return;
> > 
> > It might be "better", and this would be a nice optimization, but is it
> > needed right now?  In other words, I'd like to get this patch into
> > linux-next soon to get testing to get to Linus before 3.5-final comes
> > out, don't you?
> 
> Sure, pull it as is, and you can add my Tested-by, and Acked-by tags
> (Steven Rostedt <rostedt@goodmis.org>).
> 
> I'll send you a patch to do this update that you can queue for 3.6.
> OK?

Sounds good to me, thanks,

greg k-h
