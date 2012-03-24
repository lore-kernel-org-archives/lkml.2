Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab2CXOzg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 10:55:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19279 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab2CXOzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 10:55:35 -0400
X-Authority-Analysis: v=2.0 cv=LrMQOwhc c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=wBLf1-ka6lYA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=MIs9pYtiac-Rw8KjcOIA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 1/1] ftrace: fix dynamic ftrace filter reset issue
From: Steven Rostedt <rostedt@goodmis.org>
To: Rajesh Bhagat <rajesh.lnx@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <CA+jqyFAzpTs+JeemD7wpSgW0hmECMSPMsaZtQ7zLgn+ebXSJFQ@mail.gmail.com>
References: <CA+jqyFDRBkeAA8OPuBmAoj_ZF_HgR-U6Eu1QQ8oe_PKeN1pVFQ@mail.gmail.com>
	 <1332531400.23924.71.camel@gandalf.stny.rr.com>
	 <CA+jqyFAzpTs+JeemD7wpSgW0hmECMSPMsaZtQ7zLgn+ebXSJFQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 24 Mar 2012 09:55:05 -0400
Message-ID: <1332597305.12799.2.camel@acer.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-03-24 at 09:47 +0530, Rajesh Bhagat wrote:
> Hi Steven,
> 
> Thanks for the reply.
> 
> I was wondering, why would a user reset the trace __explicitly__
> without even using it.
> That is why i created a patch for it.
> 
> >> /debug/tracing # echo function > current_tracer
      ^
      |
   user starts using tracer

> >> /debug/tracing # cat trace <------ Not performed
> >> /debug/tracing # echo schedule > set_ftrace_filter
> >> /debug/tracing # echo function > current_trace
> >> /debug/tracing # cat trace <------- Only this is performed

Why the first "echo function"? That means you just started using the
tracer. You can (and should) do:

	# echo schedule > set_ftrace_filter
	# echo function > current_tracer

This IIRC is the documented way of using it.

That said, I may consider taking the patch, as another way of resetting
the tracer. I have to see what workflows it will affect first.

-- Steve


