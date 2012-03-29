Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933725Ab2C2TCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 15:02:42 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64223 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933594Ab2C2TCf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 15:02:35 -0400
MIME-Version: 1.0
In-Reply-To: <20120329062031.GB1376@gmail.com>
References: <1332787168-20457-1-git-send-email-vnagarnaik@google.com>
 <1332787168-20457-5-git-send-email-vnagarnaik@google.com> <4F714982.6020208@zytor.com>
 <CAL26m8Jfb8bgfDLKZtn2LkYHD6uCccD3UcsSMbHtpnUKR5_mxw@mail.gmail.com>
 <4F73CC3A.2080901@zytor.com> <CAL26m8+zbbqngfK0fYb+A2UBQ1fZ9Uxrf4VLWqU1VuMzkcF4xw@mail.gmail.com>
 <20120329062031.GB1376@gmail.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Thu, 29 Mar 2012 12:02:04 -0700
Message-ID: <CAL26m8+BmN=DxR7LbukM7S4w9XcURjfDFizUNpEcZA_8g4JNVg@mail.gmail.com>
Subject: Re: [PATCH 4/6] trace: trace syscall in its handler not from ptrace handler
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        David Sharp <dhsharp@google.com>,
        Justin Teravest <teravest@google.com>,
        Laurent Chavey <chavey@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 11:20 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Vaibhav Nagarnaik <vnagarnaik@google.com> wrote:
>
>> On Wed, Mar 28, 2012 at 7:43 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> > But instead you add a penalty for every syscall, even if tracing is
>> > disabled.  Not cool.
>>
>> I just ran a small test binary which calls syscall(SYS_getuid) in a
>> tight loop and calculates the latency per syscall.
>>
>> Without my patch: it is 70 ns/call
>> With my patch: it is 83 ns/call
>>
>> So yes, it does add a bit of latency to the syscall even if
>> tracing is disabled. I wonder if I can change the redirection
>> function so that it doesn't add so much latency.
>
> There's a really simple rule for anything tracing/debugging
> related: and syscalls don't add *ANY* kind of latency to the
> non-tracing case. That is true of the current syscall tracing
> bits, they work via a TIF flag and don't add any latency.
>

Thanks for the feedback. I had missed this added latency due to this
patch when tracing is disabled.

To fix that, instead of a TIF flag, I am using a flag in the
current->trace bitmap. I check that flag before jumping to the tracing
function. That reduces the latency from 83 ns/call to 74 ns/call.


Thanks

Vaibhav Nagarnaik
