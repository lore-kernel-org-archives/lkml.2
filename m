Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933452Ab2HPWMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 18:12:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31072 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933397Ab2HPWMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 18:12:41 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=fP8bfOivMSkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=pF7xjewShXEA:10 a=meVymXHHAAAA:8 a=u4fJ1cDnXsMBPJmWaMYA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1345155155.3708.19.camel@gandalf.local.home>
Subject: Re: [RFC PATCH -v2 3/4] perf: Add persistent event facilities
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Date: Thu, 16 Aug 2012 18:12:35 -0400
In-Reply-To: <1345139123-15212-4-git-send-email-bp@amd64.org>
References: <1345139123-15212-1-git-send-email-bp@amd64.org>
	 <1345139123-15212-4-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-16 at 19:45 +0200, Borislav Petkov wrote:
>  
> -static void ring_buffer_put(struct ring_buffer *rb)
> +void ring_buffer_put(struct ring_buffer *rb)
>  {
>  	struct perf_event *event, *n;
>  	unsigned long flags;

I have to say that it is really unfortunate that we have two ring
buffers in the kernel, called struct ring_buffer. One being global and
one being local to events. And now we are exporting the name
"ring_buffer_*" too! This is going to confuse the hell out of people.

Perhaps this should have been called perf_buffer, as that is what it's
used for.

-- Steve


