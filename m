Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab0E3PeV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 11:34:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39863 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521Ab0E3PeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 11:34:19 -0400
X-Authority-Analysis: v=1.1 cv=WC2cwRI/KXdLNEmE8ivg2cmI8vFt6dWmaZdvaJ93QHU= c=1 sm=0 a=PjWTFMnUE30A:10 a=0qYQvVkOOIcA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=uxnuuD7PqwD2Kl0nwZIA:9 a=Mim128DOxl5aIivq8LwA:7 a=xuMK44m7uZR8Dw7znGI-pJcDKpwA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
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
In-Reply-To: <4C027131.2010309@redhat.com>
References: <20100526123443.GB8905@stefan-thinkpad.transitives.com>
	 <AANLkTil8BiuzrmacV7Lpx1wES0EvLSiVmcfwtSY6Zis2@mail.gmail.com>
	 <1275083157.22648.593.camel@gandalf.stny.rr.com>
	 <4C00FF9B.9000107@redhat.com>
	 <1275139177.22648.610.camel@gandalf.stny.rr.com>
	 <4C021D7E.1060705@redhat.com>
	 <1275228182.15884.1.camel@gandalf.stny.rr.com>
	 <4C027131.2010309@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Sun, 30 May 2010 11:34:16 -0400
Message-ID: <1275233656.15884.4.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-05-30 at 17:07 +0300, Avi Kivity wrote:
> On 05/30/2010 05:03 PM, Steven Rostedt wrote:
> >
> >> Right.  The tools can fall back to %x/%s based on the structure
> >> descriptor if they can't parse the format string.
> >>
> >>      
> > trace-cmd has plugin support to override how to read the format and
> > print it out. It now has the ability to write those plugins in python.
> >    
> 
> Cool.  May make sense to use simpler formatting in the kernel, and use 
> trace-cmd plugins for the complicated cases.
> 
> It does raise issues with ABIs.  Can trace-cmd read plugins from 
> /lib/modules/*?  We can then distribute the plugins with the kernel.
> 

We probably could do that. Perhaps if we can port the python code to
perf, then it would work for both. Then the plugins could be just python
scripts, (or binary .so modules) and have a tools/plugins dir?

The python part probably would be easier to port, since the .so modules
are a bit more specific to trace-cmd.

-- Steve


