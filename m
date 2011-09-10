Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab1IJXei (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 19:34:38 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:46506 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab1IJXeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 19:34:37 -0400
Date: Sun, 11 Sep 2011 08:34:31 +0900
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH v3] Make PTRACE_SEIZE set ptrace options specified in
 'data'
Message-ID: <20110910233431.GD29319@htj.dyndns.org>
References: <1315506333.18043.49.camel@dhcp-25-63.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315506333.18043.49.camel@dhcp-25-63.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 08:22:04PM +0200, Denys Vlasenko wrote:
> Make PTRACE_SEIZE set ptrace options specified in 'data' parameter
>     
> This can be used to close a few corner cases in strace where we get
> unwanted racy behavior after attach, but before we have a chance
> to set options (the notorious post-execve SIGTRAP comes to mind),
> and removes the need to track "did we set opts for this task" state
> in strace internals.
>     
> While we are at it:
>     
> Make it possible to extend SEIZE in the future with more functionality
> by passing non-zero 'addr' parameter.
> To that end, error out if 'addr' is non-zero.
> PTRACE_ATTACH did not (and still does not) have such check,
> and users (strace) do pass garbage there... let's avoid repeating
> this mistake with SEIZE.
>     
> Set all task->ptrace bits in one operation - before this change,
> we were adding PT_SEIZED and PT_PTRACE_CAP with task->ptrace |= BIT ops.
> This was probably ok (not a bug), but let's be on a safer side.
> 
> Changes since v2: use (unsigned long) casts instead of (long) ones,
> move PTRACE_SEIZE_DEVEL-related code to separate lines of code.
> 
>     
> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
