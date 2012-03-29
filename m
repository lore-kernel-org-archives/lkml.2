Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813Ab2C2DPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 23:15:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60192 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758287Ab2C2DPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 23:15:31 -0400
Message-ID: <4F73D3C2.9080506@zytor.com>
Date: Wed, 28 Mar 2012 20:15:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        David Sharp <dhsharp@google.com>,
        Justin Teravest <teravest@google.com>,
        Laurent Chavey <chavey@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] trace: trace syscall in its handler not from ptrace
 handler
References: <1332787168-20457-1-git-send-email-vnagarnaik@google.com>  <1332787168-20457-5-git-send-email-vnagarnaik@google.com>  <4F714982.6020208@zytor.com>  <CAL26m8Jfb8bgfDLKZtn2LkYHD6uCccD3UcsSMbHtpnUKR5_mxw@mail.gmail.com>  <4F73CC3A.2080901@zytor.com> <1332989953.23924.183.camel@gandalf.stny.rr.com>
In-Reply-To: <1332989953.23924.183.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2012 07:59 PM, Steven Rostedt wrote:
> On Wed, 2012-03-28 at 19:43 -0700, H. Peter Anvin wrote:
> 
>> The syscall interface is the single most stable interface in the kernel.
>>  Just plunk down the system call number and the six arguments in the
>> buffer, and be done with it.  On the way out, there is a single return
>> argument, *by design*.  No need to burden the kernel in this way! That
>> this information can be perfectly well decoded in userspace is already
>> shown by strace, although it would be highly beneficial if the kernel
>> build could export information to strace and other tools.  There is
>> absolutely no need for it to live in kernel memory, though.
> 
> Even if it did live in kernel memory (which it does now, and I'm not
> sure if we can change it due to the *don't break existing tools* law).
> We should be able to at least compress it so that it doesn't waste as
> much memory.
> 

This whole facility is the logical equivalent of doing binary-to-ascii
conversion with a switch statement:

switch (foo)
{
	case 0:
		printf("0");
		break;

	case 1:
		printf("1");
		break;

	case 2:
		printf("2");
		break;

	/* ... */
}

We see that kind of code on The Daily WTF all the time, but it has no
excuse being seen anywhere close to the Linux kernel.

Furthermore, if we can't even fix grotesque brokenness like this in
*debugging tools*, then we might as well go home, as there is absolutely
no hope to ever make forward progress.  This is worse than "let's pick
up a bunch of random kernel internals and make them stable ABIs" Xen.

	-hpa

