Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078Ab1D2UBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 16:01:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39034 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391Ab1D2UBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 16:01:17 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=vVy0PQ3ZQx8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=8cYTcFRtT2wx23DzZDUA:9 a=JvPdCk_vDXSHiNLQC6gA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] trace: Add a free on close control mechanism for
 buffer_size_kb
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>
In-Reply-To: <BANLkTimY9weoBhiQv+dfS4UzYPGBFDdPQQ@mail.gmail.com>
References: <1303512373-25992-1-git-send-email-vnagarnaik@google.com>
	 <1304033561.18763.212.camel@gandalf.stny.rr.com>
	 <BANLkTimY9weoBhiQv+dfS4UzYPGBFDdPQQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 29 Apr 2011 16:01:15 -0400
Message-ID: <1304107275.18763.279.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-29 at 12:45 -0700, Vaibhav Nagarnaik wrote:

> > Why call it "atomic"? Because you do the mutex? Anyway I hate the name.
> > It sounds like it can do it without preemption, which it clearly can't
> > do.
> 
> I just wanted to note that it was a locked operation. I have changed the name
> to tracing_buffer_resize_locked.
> 
> If you think it can be named better, I will change it.

Actually, the normal convention that I noticed that is used around the
kernel is the "normal" name is used when locking is applied. For
functions that do the same thing but does not lock, add two underscores
in front of the name:


void __foo(void)
{
	do_foo();
}

void foo(void)
{
	mutex_lock(&foo_lock);
	__foo();
	mutex_unlock(&foo_lock);
}

But if this has no real equivalent, just remove that name altogether.

Not to lock should be the exception, not locking.

-- Steve


