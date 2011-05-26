Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758305Ab1EZUWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 16:22:32 -0400
Received: from smtp-out.google.com ([74.125.121.67]:16249 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237Ab1EZUWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 16:22:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=hvwQ8Ldk80mxpracmbvQkEnF7wCHDCwRDC+TqF3ZEpnNdm0FWC9CYldrJtI3oPI+sc
         G3Tyd5oXKAtI5SqruRiQ==
Date: Thu, 26 May 2011 13:22:26 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Steven Rostedt <rostedt@goodmis.org>
cc: Vaibhav Nagarnaik <vnagarnaik@google.com>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trace: Set oom_score_adj to maximum for ring buffer
 allocating process
In-Reply-To: <1306440288.3857.9.camel@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.1105261315330.29101@chino.kir.corp.google.com>
References: <1306439537-23706-1-git-send-email-vnagarnaik@google.com> <1306440288.3857.9.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 May 2011, Steven Rostedt wrote:

> Hmm, have you tried this in practice? Yes we may kill the "echo" command
> but it doesn't stop the ring buffer from being allocated, and thus
> killing the echo command may not be enough, and those critical processes
> that you are trying to protect will be killed next.
> 
> Perhaps we should change the allocation of the ring buffer or detect OOM
> triggering. Maybe make all the allocations ATOMIC, thus it will be
> either available or not, and fail instead of trying to swap out other
> memory for the allocation.
> 

My impression of this was that it was attempting to avoid killing a 
different process by means of the oom killer rather than avoiding swap.  I 
don't think there's anything wrong with using GFP_KERNEL, but I'd suggest 
also using __GFP_NORETRY so the allocation calls into direct reclaim but 
will avoid oom killing anything and simply failing instead.
