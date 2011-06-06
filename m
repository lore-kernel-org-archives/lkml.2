Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082Ab1FFVpL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 17:45:11 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48813 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab1FFVpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 17:45:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=enoDoBgECgp5VJCpq/aAmJMms+bVi4VGoY7x1Xi3QUscgn2tufw2XTi/z/5aj2qY4P
         XGVYqlOtwasxnD02siJADEMAG0SCQRYVUw4+JbpW3vnyopt10ZjIpmK6EP/+XAsLRKSg
         xunTR0ln/fmFtc2sm1OTpa4RdjKvbKdZFLlJs=
Date: Mon, 6 Jun 2011 23:45:04 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sam@ravnborg.org, torvalds@linux-foundation.org, tglx@linutronix.de,
        josh@joshtriplett.org, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/debug] debug: Make CONFIG_EXPERT select
 CONFIG_DEBUG_KERNEL to unhide debug options
Message-ID: <20110606214502.GB17026@somewhere.redhat.com>
References: <20110606165130.GA1844@leaf>
 <tip-2458073da04571182748aa4289630dca52ba63cc@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-2458073da04571182748aa4289630dca52ba63cc@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 09:39:40PM +0000, tip-bot for Josh Triplett wrote:
> Commit-ID:  2458073da04571182748aa4289630dca52ba63cc
> Gitweb:     http://git.kernel.org/tip/2458073da04571182748aa4289630dca52ba63cc
> Author:     Josh Triplett <josh@joshtriplett.org>
> AuthorDate: Mon, 6 Jun 2011 09:51:30 -0700
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 6 Jun 2011 19:30:01 +0200
> 
> debug: Make CONFIG_EXPERT select CONFIG_DEBUG_KERNEL to unhide debug options
> 
> Several debugging options currently default to y, such as
> CONFIG_DEBUG_BUGVERBOSE and CONFIG_DEBUG_RODATA.
> 
> Embedded users might want to turn those options off to save space;
> however, turning them off requires turning on CONFIG_DEBUG_KERNEL to
> unhide them.  Since CONFIG_DEBUG_KERNEL exists specifically to
> unhide debugging options, and CONFIG_EXPERT exists specifically
> to unhide options potentially needed by experts and/or embedded
> users, make CONFIG_EXPERT automatically imply CONFIG_DEBUG_KERNEL.
> 
> Change various debugging options to only reference DEBUG_KERNEL,
> not EXPERT.
> 
> Note that DEBUG_MEMORY_INIT defaulted to !EXPERT, which seemed
> wrong, since EXPERT should not directly affect anything except
> the availability of other options.  (And EXPERT definitely
> shouldn't mean "implicitly turn off default safety features".)
> 
> Change it to default to y, which means that turning on EXPERT
> does not automatically disable it, but will provide the option
> to disable it.
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

No, Nacked actually. I'm fine with the v2 that only changed
the EXPERT config to imply DEBUG_KERNEL. But all the other
changes here need to be revised, as I outlined in the thread.
