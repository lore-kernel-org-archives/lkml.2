Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab0FAL7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 07:59:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56547 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab0FAL7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 07:59:09 -0400
X-Authority-Analysis: v=1.1 cv=EbJB9AiBqsyZPMVATYsj78CfMiBiOs+4P7kRKNQkfg0= c=1 sm=0 a=PjWTFMnUE30A:10 a=0qYQvVkOOIcA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=5vTwxQwy-NLxs3pkj-oA:9 a=Q0ESIHjJbWByVLmchJ4A:7 a=zjoW2GO5q2nIWNJAF4GEsmF2UF0A:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: Perf trace event parse errors for KVM events
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Avi Kivity <avi@redhat.com>
Cc: Stefan Hajnoczi <stefanha@gmail.com>, linux-perf-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
       Johannes Berg <johannes.berg@intel.com>,
       Darren Hart <darren@dvhart.com>
In-Reply-To: <4C04C739.8050607@redhat.com>
References: <20100526123443.GB8905@stefan-thinkpad.transitives.com>
	 <AANLkTil8BiuzrmacV7Lpx1wES0EvLSiVmcfwtSY6Zis2@mail.gmail.com>
	 <1275083157.22648.593.camel@gandalf.stny.rr.com>
	 <4C00FF9B.9000107@redhat.com>
	 <1275139177.22648.610.camel@gandalf.stny.rr.com>
	 <4C021D7E.1060705@redhat.com>
	 <1275228182.15884.1.camel@gandalf.stny.rr.com>
	 <4C027131.2010309@redhat.com>
	 <1275233656.15884.4.camel@gandalf.stny.rr.com>
	 <4C04C739.8050607@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 01 Jun 2010 07:59:04 -0400
Message-ID: <1275393544.15884.19.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-01 at 11:39 +0300, Avi Kivity wrote:
> On 05/30/2010 06:34 PM, Steven Rostedt wrote:
> >
> >> Cool.  May make sense to use simpler formatting in the kernel, and use
> >> trace-cmd plugins for the complicated cases.
> >>
> >> It does raise issues with ABIs.  Can trace-cmd read plugins from
> >> /lib/modules/*?  We can then distribute the plugins with the kernel.
> >>
> >>      
> > We probably could do that. Perhaps if we can port the python code to
> > perf, then it would work for both. Then the plugins could be just python
> > scripts, (or binary .so modules) and have a tools/plugins dir?
> >
> > The python part probably would be easier to port, since the .so modules
> > are a bit more specific to trace-cmd.
> >    
> 
> One concern is performance.  Traces tend to be long, and running python 
> code on each line will be slow.
> 
> If trace-cmd integrates a pager and a search mechanism that looks at the 
> binary data instead of the text, we could format only the lines that are 
> displayed.  But that is going to be a lot of work and I don't think it's 
> worth the effort.
> 

Every event gets its own ID. The plugin registers a callback to that ID.
When the ID is hit, the plugin is executed on that event to display its
binary format.

This is done after the data has been saved in binary format to a file.
It may slow down the executing of reading a data file, but it does not
affect the running of the trace one bit.

-- Steve


