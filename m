Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760215Ab2C2Woe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 18:44:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40675 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760171Ab2C2Wo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 18:44:27 -0400
Message-ID: <4F74E5B8.7050905@zytor.com>
Date: Thu, 29 Mar 2012 15:44:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: David Sharp <dhsharp@google.com>
CC: Vaibhav Nagarnaik <vnagarnaik@google.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Justin Teravest <teravest@google.com>,
        Laurent Chavey <chavey@google.com>, Michael Davidson <md@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] trace: trace syscall in its handler not from ptrace
 handler
References: <1332787168-20457-1-git-send-email-vnagarnaik@google.com> <1332787168-20457-5-git-send-email-vnagarnaik@google.com> <4F714982.6020208@zytor.com> <CAL26m8Jfb8bgfDLKZtn2LkYHD6uCccD3UcsSMbHtpnUKR5_mxw@mail.gmail.com> <4F73CC3A.2080901@zytor.com> <CAL26m8+zbbqngfK0fYb+A2UBQ1fZ9Uxrf4VLWqU1VuMzkcF4xw@mail.gmail.com> <20120329062031.GB1376@gmail.com> <CAL26m8+BmN=DxR7LbukM7S4w9XcURjfDFizUNpEcZA_8g4JNVg@mail.gmail.com> <4F74B42F.3050100@zytor.com> <CAL26m8JA4HJQayJW2nYbVpHD7mgd0Bz6rFMipq2Nf6OECiyk1Q@mail.gmail.com> <4F74C0B2.1010100@zytor.com> <CAJL_ekvU8sjt0wi6GjrMiqy03kBZ6YzQkz9TO+MQzQAr_-2VnQ@mail.gmail.com>
In-Reply-To: <CAJL_ekvU8sjt0wi6GjrMiqy03kBZ6YzQkz9TO+MQzQAr_-2VnQ@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2012 03:40 PM, David Sharp wrote:
> On Thu, Mar 29, 2012 at 1:06 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> I had a long discussion with Frederic over IRC earlier today.  We came
>> up with the following strawman:
>>
>> 1. A system call thunk (which could be enabled/disabled by patching the
>> syscall table.)  This provides an entry and exit hook, and also sets a
>> per-thread flag to capture userspace traffic.
> 
> Our goal is for syscall traces to be as fast as regular tracepoints.
> iirc, What we've found is that much of the extra overhead of syscall
> tracepoints as compared to regular tracepoints is due to that the code
> path for syscall tracing is bundled with checks for ptrace and other
> stuff (Vaibhav did all this characterization, he can jump in with
> details if wanted). How much work would this "thunk" have to do that
> is not either recording the trace or calling the syscall?

Nothing.  That IS what the thunk would do:

thunk:
	<record syscall entry>
	call real_syscall_table(syscall_number)
	<record syscall exit>
	ret

	-hpa
