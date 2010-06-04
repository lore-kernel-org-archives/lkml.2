Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab0FDDDO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 23:03:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58643 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757071Ab0FDDDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 23:03:12 -0400
X-Authority-Analysis: v=1.1 cv=DT5lrGikL/lNZzMKzbmp3iVCACewI9NZ3q1CIi1KGbI= c=1 sm=0 a=XL1Npt1c_1MA:10 a=yQWWgrYGNuUA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=UM6lsJRAT-N35CRzOUgA:9 a=wwXcmPa1lBVkV70qnC3x_VqrKqkA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] tracing: reduce latency and remove percpu trace_seq
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Theodore Tso <tedtso@gmail.com>, Theodore Tso <tytso@mit.edu>
In-Reply-To: <4C0863BD.6000307@cn.fujitsu.com>
References: <4C078350.7090106@cn.fujitsu.com>
	 <1275572170.15884.30.camel@gandalf.stny.rr.com>
	 <4C0863BD.6000307@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 03 Jun 2010 23:03:10 -0400
Message-ID: <1275620590.15884.70.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-04 at 10:23 +0800, Lai Jiangshan wrote:
> Steven Rostedt wrote:
> 
> > 
> > The "print" in the trace_seq_printf() is the TP_printk() field of the
> > TRACE_EVENT. I believe that there were some events (ext4?) that did
> > things that required preemption disabled.
> > 
> 
> It seems that ext4 has no such events.
> I find jbd2_dev_to_name() in the TP_printk() field of ext4's tracepoints.
> And it seems that jbd2_dev_to_name() requires preemption enabled and sleepable.
> 
> Maybe there were some events did things that required preemption disabled.
> But No document ensure TP_printk() preemption disabled, such events should
> be fixed, I think.

Well, I had a private email conversation with Ted last year where IIRC,
adding the preempt disable would fix things.

I'd like to make sure Ted is OK with removing that before we do so.

Ted?

-- Steve


