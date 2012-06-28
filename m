Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444Ab2F1C6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 22:58:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22133 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243Ab2F1C62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 22:58:28 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=pf8V27uzMmYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=pHR_4iPrrHIDTpecX44A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340852306.16702.74.camel@gandalf.stny.rr.com>
Subject: Re: big allocation failure during tracing init.
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Date: Wed, 27 Jun 2012 22:58:26 -0400
In-Reply-To: <20120628022218.GA30698@redhat.com>
References: <20120622193650.GA20098@redhat.com>
	 <1340844763.16702.54.camel@gandalf.stny.rr.com>
	 <20120628022218.GA30698@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-27 at 22:22 -0400, Dave Jones wrote:
> On Wed, Jun 27, 2012 at 08:52:43PM -0400, Steven Rostedt wrote:
>  > On Fri, 2012-06-22 at 15:36 -0400, Dave Jones wrote:
>  > 
>  > > I guess the problem is on kernels built with CONFIG_MAXCPUS, struct trace_iterator
>  > > can be pretty large due to this embedded in it..
>  > > 
>  > > 	struct ring_buffer_iter *buffer_iter[NR_CPUS];
>  > > 
>  > > Any thoughts on how to change that to a smaller dynamic data structure,
>  > > without adding too much overhead to tracing ? (I'm assuming a linked-list walk
>  > > for eg would be excessive?)
>  > > 
>  > 
>  > Does this patch fix it for you?
> 
> I'm not sure what I did to trigger the allocation failure last time,
> but I'll run with this for a while, and see if anything falls out.

You probably need to do some tracing to trigger it. As it requires
opening of the trace files.

-- Steve


