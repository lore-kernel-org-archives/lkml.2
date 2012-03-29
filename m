Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581Ab2C2DD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 23:03:27 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42929 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab2C2DDY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 23:03:24 -0400
MIME-Version: 1.0
In-Reply-To: <4F73CC3A.2080901@zytor.com>
References: <1332787168-20457-1-git-send-email-vnagarnaik@google.com>
 <1332787168-20457-5-git-send-email-vnagarnaik@google.com> <4F714982.6020208@zytor.com>
 <CAL26m8Jfb8bgfDLKZtn2LkYHD6uCccD3UcsSMbHtpnUKR5_mxw@mail.gmail.com> <4F73CC3A.2080901@zytor.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Wed, 28 Mar 2012 20:02:54 -0700
Message-ID: <CAL26m8+zbbqngfK0fYb+A2UBQ1fZ9Uxrf4VLWqU1VuMzkcF4xw@mail.gmail.com>
Subject: Re: [PATCH 4/6] trace: trace syscall in its handler not from ptrace handler
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
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

On Wed, Mar 28, 2012 at 7:43 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> But instead you add a penalty for every syscall, even if tracing is
> disabled.  Not cool.

I just ran a small test binary which calls syscall(SYS_getuid) in a
tight loop and calculates the latency per syscall.

Without my patch: it is 70 ns/call
With my patch: it is 83 ns/call

So yes, it does add a bit of latency to the syscall even if tracing is
disabled. I wonder if I can change the redirection function so that it
doesn't add so much latency.

But if it doesn't seem to help, then I will not push this patch.



Vaibhav Nagarnaik
