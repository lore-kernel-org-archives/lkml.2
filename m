Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760237Ab2C2Wsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 18:48:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40714 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760183Ab2C2Wst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 18:48:49 -0400
Message-ID: <4F74E6C2.8050003@zytor.com>
Date: Thu, 29 Mar 2012 15:48:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: David Sharp <dhsharp@google.com>
CC: Vaibhav Nagarnaik <vnagarnaik@google.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Justin Teravest <teravest@google.com>,
        Laurent Chavey <chavey@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] trace: trace syscall in its handler not from ptrace
 handler
References: <1332787168-20457-1-git-send-email-vnagarnaik@google.com> <1332787168-20457-5-git-send-email-vnagarnaik@google.com> <4F714982.6020208@zytor.com> <CAL26m8Jfb8bgfDLKZtn2LkYHD6uCccD3UcsSMbHtpnUKR5_mxw@mail.gmail.com> <4F73CC3A.2080901@zytor.com> <CAL26m8+zbbqngfK0fYb+A2UBQ1fZ9Uxrf4VLWqU1VuMzkcF4xw@mail.gmail.com> <20120329062031.GB1376@gmail.com> <CAL26m8+BmN=DxR7LbukM7S4w9XcURjfDFizUNpEcZA_8g4JNVg@mail.gmail.com> <4F74B42F.3050100@zytor.com> <CAJL_ektkRunH_FXL+VfPCZqyNvB3Ab4PNjwzF2_dORudr0a32g@mail.gmail.com>
In-Reply-To: <CAJL_ektkRunH_FXL+VfPCZqyNvB3Ab4PNjwzF2_dORudr0a32g@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2012 03:44 PM, David Sharp wrote:
>>
>> ANY increase to the fastpath is unacceptable, period.
> 
> I think the last 4 ns would probably be eliminated if we could figure
> out how to call the inline function trace_sys_enter directly instead
> of through the out-of-line wrapper we had to add to work around the
> preprocessor magic.

I already told you how to do it... override the system call table entry.
 There is a nice, juicy FUNCTION POINTER that we indirect through.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

