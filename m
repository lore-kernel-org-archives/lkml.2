Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758466Ab1EZXYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 19:24:33 -0400
Received: from smtp-out.google.com ([74.125.121.67]:31209 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301Ab1EZXYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 19:24:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=VQI/Kcj6V2Yn0NMYRYLcczcwTqaucqoadEG2zFHG6jvz6vGcIJGajuc+6SIVkY/ax4
         8ktCaYZFne9oUiKNcSLQ==
MIME-Version: 1.0
In-Reply-To: <1306443612.3857.15.camel@gandalf.stny.rr.com>
References: <1306439537-23706-1-git-send-email-vnagarnaik@google.com>
 <1306440288.3857.9.camel@gandalf.stny.rr.com> <BANLkTi=dEHG4zEZ2xRF7VEDdM6fsd9Hr=g@mail.gmail.com>
 <alpine.DEB.2.00.1105261328200.29812@chino.kir.corp.google.com> <1306443612.3857.15.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Thu, 26 May 2011 16:23:58 -0700
Message-ID: <BANLkTim_DLbOXrmRdMeOa9FhhqEgjMVZDg@mail.gmail.com>
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

On Thu, May 26, 2011 at 2:00 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> I'm thinking the oom killer used here got lucky. As it killed this task,
> we were still out of memory, and the ring buffer failed to get the
> memory it needed and freed up everything that it previously allocated,
> and returned. Then the process calling this function would be killed by

I have tested this multiple times and I don't see any other process
being killed, regardless of who invoked oom-killer. The oom-killer
always selects the "echo" process to kill because of its maximum
oom_score_adj and sets TIF_MEMDIE. Since the ring buffer is still
getting allocated, any further allocation from this process fails
because of this flag and the fatal signal pending. This causes the ring
buffer memory to be freed.

I don't see the oom-killer getting lucky in my test cases.


Vaibhav Nagarnaik
