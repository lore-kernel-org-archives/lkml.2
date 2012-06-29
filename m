Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab2F2LSm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 07:18:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32504 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab2F2LSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 07:18:41 -0400
X-Authority-Analysis: v=2.0 cv=StQSGYy0 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=EvKSwpK77UAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=59w9SamwkGhfydPAhz8A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340968718.16702.98.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v3] printk: Have printk() never buffer its data
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kay Sievers <kay@vrfy.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Wu Fengguang <fengguang.wu@intel.com>, Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Date: Fri, 29 Jun 2012 07:18:38 -0400
In-Reply-To: <20120629053027.GA9841@kroah.com>
References: <20120626002307.GA4389@kroah.com>
	 <CA+55aFxhYRqcU2EUmcsuLrhgo4FEO6-b+mB57wB3JRiXEp3ZrA@mail.gmail.com>
	 <CAPXgP10cPFSmZ5yr6Z4wVtDa+x2J1yQDF57NJXtxjUuxMHm=Lw@mail.gmail.com>
	 <CA+55aFzkX=jCC1O6+2oz8meswOqZQ+Q8Ao60q8eAS1G3AuEStQ@mail.gmail.com>
	 <1340726856.977.6.camel@mop>
	 <1340810038.16702.16.camel@gandalf.stny.rr.com>
	 <1340810283.16702.19.camel@gandalf.stny.rr.com>
	 <CAPXgP121+zA_p4x9VdSMWtu-SqqqiNC51CKkYKY4YkAL+QsQ4g@mail.gmail.com>
	 <1340869133.876.10.camel@mop>
	 <1340852129.16702.73.camel@gandalf.stny.rr.com>
	 <20120629053027.GA9841@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-29 at 01:30 -0400, Greg Kroah-Hartman wrote:
>  
> > I wonder if it would be better to do the following for the above two
> > ifs:
> > 
> > 	if (cont.len && cont.owner == current) {
> > 		if (!prefix)
> > 			stored = cont_add(facility, level, text, text_len);
> > 		cont_flush();
> > 	}
> > 
> > If the prefix was true, then the cont.flush would be set when cont_add()
> > is called, and the first thing that cont_add() does:
> > 
> > 	if (cont.len && cont.flushed)
> > 		return false;
> > 
> > which would always be true (returning false) if prefix was set.
> > 
> > And the second cont_flush() is a nop due to it doing:
> > 
> > 	if (cont.flushed)
> > 		return;
> 
> It might be "better", and this would be a nice optimization, but is it
> needed right now?  In other words, I'd like to get this patch into
> linux-next soon to get testing to get to Linus before 3.5-final comes
> out, don't you?

Sure, pull it as is, and you can add my Tested-by, and Acked-by tags
(Steven Rostedt <rostedt@goodmis.org>).

I'll send you a patch to do this update that you can queue for 3.6.
OK?

-- Steve


