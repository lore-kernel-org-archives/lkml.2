Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216Ab2C2C7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 22:59:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24191 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab2C2C7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 22:59:16 -0400
X-Authority-Analysis: v=2.0 cv=Z8Fu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=oix_wqQkZ80A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=UNxasA3ZaOMBbe4kUYcA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1332989953.23924.183.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 4/6] trace: trace syscall in its handler not from ptrace
 handler
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        David Sharp <dhsharp@google.com>,
        Justin Teravest <teravest@google.com>,
        Laurent Chavey <chavey@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 28 Mar 2012 22:59:13 -0400
In-Reply-To: <4F73CC3A.2080901@zytor.com>
References: <1332787168-20457-1-git-send-email-vnagarnaik@google.com>
	 <1332787168-20457-5-git-send-email-vnagarnaik@google.com>
	 <4F714982.6020208@zytor.com>
	 <CAL26m8Jfb8bgfDLKZtn2LkYHD6uCccD3UcsSMbHtpnUKR5_mxw@mail.gmail.com>
	 <4F73CC3A.2080901@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-28 at 19:43 -0700, H. Peter Anvin wrote:

> The syscall interface is the single most stable interface in the kernel.
>  Just plunk down the system call number and the six arguments in the
> buffer, and be done with it.  On the way out, there is a single return
> argument, *by design*.  No need to burden the kernel in this way! That
> this information can be perfectly well decoded in userspace is already
> shown by strace, although it would be highly beneficial if the kernel
> build could export information to strace and other tools.  There is
> absolutely no need for it to live in kernel memory, though.

Even if it did live in kernel memory (which it does now, and I'm not
sure if we can change it due to the *don't break existing tools* law).
We should be able to at least compress it so that it doesn't waste as
much memory.

-- Steve


