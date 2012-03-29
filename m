Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760225Ab2C2WpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 18:45:09 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59720 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760179Ab2C2WpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 18:45:03 -0400
MIME-Version: 1.0
In-Reply-To: <4F74B42F.3050100@zytor.com>
References: <1332787168-20457-1-git-send-email-vnagarnaik@google.com>
 <1332787168-20457-5-git-send-email-vnagarnaik@google.com> <4F714982.6020208@zytor.com>
 <CAL26m8Jfb8bgfDLKZtn2LkYHD6uCccD3UcsSMbHtpnUKR5_mxw@mail.gmail.com>
 <4F73CC3A.2080901@zytor.com> <CAL26m8+zbbqngfK0fYb+A2UBQ1fZ9Uxrf4VLWqU1VuMzkcF4xw@mail.gmail.com>
 <20120329062031.GB1376@gmail.com> <CAL26m8+BmN=DxR7LbukM7S4w9XcURjfDFizUNpEcZA_8g4JNVg@mail.gmail.com>
 <4F74B42F.3050100@zytor.com>
From: David Sharp <dhsharp@google.com>
Date: Thu, 29 Mar 2012 15:44:41 -0700
Message-ID: <CAJL_ektkRunH_FXL+VfPCZqyNvB3Ab4PNjwzF2_dORudr0a32g@mail.gmail.com>
Subject: Re: [PATCH 4/6] trace: trace syscall in its handler not from ptrace handler
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Justin Teravest <teravest@google.com>,
        Laurent Chavey <chavey@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 12:12 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 03/29/2012 12:02 PM, Vaibhav Nagarnaik wrote:
>>
>> Thanks for the feedback. I had missed this added latency due to this
>> patch when tracing is disabled.
>>
>> To fix that, instead of a TIF flag, I am using a flag in the
>> current->trace bitmap. I check that flag before jumping to the tracing
>> function. That reduces the latency from 83 ns/call to 74 ns/call.
>>
>
> ANY increase to the fastpath is unacceptable, period.

I think the last 4 ns would probably be eliminated if we could figure
out how to call the inline function trace_sys_enter directly instead
of through the out-of-line wrapper we had to add to work around the
preprocessor magic.
