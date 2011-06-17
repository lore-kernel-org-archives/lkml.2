Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab1FQJ4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 05:56:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60348 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab1FQJ4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 05:56:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=URo9yoLpit4afXJAjsxE+BHudY0ny1MxIAvHZnRVE7oyHB2oisgO3ogRl68XX/P30m
         24dM/Z77nly0S/1tK92lzxaWGwUTkwI5IUyFBPwR0sb3f0abfJzr3lxi1CZzI4PniTpJ
         DRfZa36eDsO0T7Sex/IOZqj2NMiuR8TiUlGgg=
Date: Fri, 17 Jun 2011 13:56:25 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, kernel-hardening@lists.openwall.com
Subject: Re: How to temporary change 'current' (task)
Message-ID: <20110617095625.GA7627@albatros>
References: <20110617083651.GA5625@albatros>
 <1308302957.2355.5.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308302957.2355.5.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 11:29 +0200, Peter Zijlstra wrote:
> On Fri, 2011-06-17 at 12:36 +0400, Vasiliy Kulikov wrote:
> > I wonder whether there is a simple way to temporary switch 'current' to
> > another task and then switch it back with minimum side effects? 
> 
> No.

After a moment's thought, it would also break some synchronization that
relies on some structures are accesses only from the current task.

> >  I need
> > it to call "reversed" ptrace_may_access() with swapped current and
> > target task.  Introducing ptrace_task_may_access_me() would produce too
> > much noise in LSM (it also needs reversed security_ptrace_access_check()),
> > which is too loud for my needs.
> > 
> > Specifically, I need it to filter taskstats and proc connector requests
> > for a restriction of getting other processes' information:
> > 
> > http://permalink.gmane.org/gmane.linux.kernel/1155354
> > 
> > As the check is handled in the context of the ptrace target process,
> > ptrace_may_access() doesn't fit my needs.
> 
> looking at __ptrace_may_access() it doesn't look too hard to make it
> take two task arguments and use __task_cred() twice instead of
> current_cred().
> 
> It of course needs extending security_ptrace_access_check() as well, but
> that comes with the territory.

Well, yes, but it implies pushing explicit ptrace actor into LSM
modules.  OK, it should be not as noisy as I initially thought - almost
all current LSMs already use "current" as an explicit argument in
theirs internal functions.

Thank you,

-- 
Vasiliy
