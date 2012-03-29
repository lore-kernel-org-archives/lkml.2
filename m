Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab2C2GUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 02:20:44 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41328 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557Ab2C2GUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 02:20:36 -0400
Date: Thu, 29 Mar 2012 08:20:31 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        David Sharp <dhsharp@google.com>,
        Justin Teravest <teravest@google.com>,
        Laurent Chavey <chavey@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] trace: trace syscall in its handler not from ptrace
 handler
Message-ID: <20120329062031.GB1376@gmail.com>
References: <1332787168-20457-1-git-send-email-vnagarnaik@google.com>
 <1332787168-20457-5-git-send-email-vnagarnaik@google.com>
 <4F714982.6020208@zytor.com>
 <CAL26m8Jfb8bgfDLKZtn2LkYHD6uCccD3UcsSMbHtpnUKR5_mxw@mail.gmail.com>
 <4F73CC3A.2080901@zytor.com>
 <CAL26m8+zbbqngfK0fYb+A2UBQ1fZ9Uxrf4VLWqU1VuMzkcF4xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL26m8+zbbqngfK0fYb+A2UBQ1fZ9Uxrf4VLWqU1VuMzkcF4xw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vaibhav Nagarnaik <vnagarnaik@google.com> wrote:

> On Wed, Mar 28, 2012 at 7:43 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> > But instead you add a penalty for every syscall, even if tracing is
> > disabled.  Not cool.
> 
> I just ran a small test binary which calls syscall(SYS_getuid) in a
> tight loop and calculates the latency per syscall.
> 
> Without my patch: it is 70 ns/call
> With my patch: it is 83 ns/call
> 
> So yes, it does add a bit of latency to the syscall even if 
> tracing is disabled. I wonder if I can change the redirection 
> function so that it doesn't add so much latency.

There's a really simple rule for anything tracing/debugging 
related: and syscalls don't add *ANY* kind of latency to the 
non-tracing case. That is true of the current syscall tracing 
bits, they work via a TIF flag and don't add any latency.

Thanks,

	Ingo
