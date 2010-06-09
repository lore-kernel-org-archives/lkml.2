Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab0FIV6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 17:58:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60311 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab0FIV6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 17:58:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WI3Dlf5EFOf49BSudTRpRsqhgruA/meJIYdCPIktmZIZyXI88LVs4Z2adhnJWTUA7b
         xC2q9PGibEfFI+bL8PSyhQfn4rV7zlEXPzryHqL6EyDMtiO/0DsfVc4YwERLx7hQmPsl
         qFw5qETMAbatwFbH6rceD2nhGdgAX8KP6lLHs=
Date: Wed, 9 Jun 2010 23:58:13 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com, avi@redhat.com, davem@davemloft.net,
       vgoyal@redhat.com, sam@ravnborg.org
Subject: Re: [PATCH 01/13] jump label v9: notifier atomic call chain notrace
Message-ID: <20100609215810.GA12752@nowhere>
References: <cover.1276116186.git.jbaron@redhat.com> <dd363dd9bd8e4d3f6330f4b573dae40b76bd6dd8.1276116186.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd363dd9bd8e4d3f6330f4b573dae40b76bd6dd8.1276116186.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 09, 2010 at 05:38:52PM -0400, Jason Baron wrote:
> From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> 
> In LTTng, being able to use the atomic notifier from cpu idle entry to
> ensure the tracer flush the last events in the current subbuffer
> requires the rcu read-side to be marked "notrace", otherwise it can end
> up calling back into lockdep and the tracer.
> 
> Also apply to the the die notifier.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> Reviewed-by: Masami Hiramatsu <mhiramat@redhat.com>
> ---



I don't understand the purpose of this patch. The only notifier
I see that is used by jmp label is the module notifier, and I
don't see how it can do bad things if we don't use the notrace
version.

