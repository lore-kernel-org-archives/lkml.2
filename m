Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab1FGXbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 19:31:11 -0400
Received: from smtp-out.google.com ([74.125.121.67]:37068 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab1FGXbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 19:31:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=u5Zgl0QTpFmC6vygFFIxLnISVJXf3l083ktYPe5B26jTBQ5XB9P3h26qD59cG1qQsr
         vbMoDRJit35EM6+VQJhQ==
MIME-Version: 1.0
In-Reply-To: <1307488061.9218.16.camel@gandalf.stny.rr.com>
References: <1306439537-23706-1-git-send-email-vnagarnaik@google.com>
 <1306519125-19301-1-git-send-email-vnagarnaik@google.com> <alpine.DEB.2.00.1105271618470.9445@chino.kir.corp.google.com>
 <BANLkTimfdkpY=9pgEmBZwE3ezCmooEtQTA@mail.gmail.com> <1306547453.3857.44.camel@gandalf.stny.rr.com>
 <BANLkTik5yUMVpdPmELMZfmGE=JZRQCQQ2Q@mail.gmail.com> <1307488061.9218.16.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Tue, 7 Jun 2011 16:30:11 -0700
Message-ID: <BANLkTinnWe57njB6XE2CaLQB_r1h13V+3E0eW91Dxer=0DL4-w@mail.gmail.com>
Subject: Re: [PATCH] trace: Set oom_score_adj to maximum for ring buffer
 allocating process
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 7, 2011 at 4:07 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Hi Vaibhav,
>
> I'm going though patches for v3.1 now. Where are we on this issue. I
> still don't really like the ideal of having the kernel set the oom
> policy by default. But I'm totally fine with changing the allocations
> for NORETRY.
>
> If you switch it to NORETRY, do you still have the issues you were
> seeing? You could also add userspace helpers that would set the oom
> policy of things accessing the ring buffer.
>
> Either have a script that updates the ring buffer size and sets the oom
> policy, or have a library with a helper routine.
>
> Would those be fine for you?
>
> -- Steve
>
I understand your hesitation to change the kernel oom policy for
allocating the ring buffer. I am fine with just using __GFP_NORETRY for
allocation calls to fail more gracefully. It works for most of the use
cases I encounter.

We will make changes to our internal tools to make sure that
oom_score_adj is changed to pick the allocating process for oom-killing.

I will send the updated patch.


Thanks

Vaibhav Nagarnaik
