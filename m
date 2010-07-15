Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934601Ab0GOTxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 15:53:52 -0400
Received: from smtp-out.google.com ([216.239.44.51]:24089 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934530Ab0GOTxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 15:53:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=I+WyvrCfs3ypnC8LhbSroMUvMCW9qvwlUlFHpW6Pn7jt9UPTg4n9B/svqwg6M7h80
	pWJ98VoResAqG1iuTSz0Q==
Date: Thu, 15 Jul 2010 12:53:43 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, andi.kleen@intel.com
Subject: Re: [PATCH] Don't apply for write lock on tasklist_lock if parent
 doesn't ptrace other processes
In-Reply-To: <1279176663.2096.1264.camel@ymzhang.sh.intel.com>
Message-ID: <alpine.DEB.2.00.1007151250430.29400@chino.kir.corp.google.com>
References: <1279176663.2096.1264.camel@ymzhang.sh.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jul 2010, Zhang, Yanmin wrote:

> We run some sub-cases (fork, exec, pipe, tcp, udp) of aim7 on 8-socket machine.
> Perf shows write_lock_irq(&tasklist_lock) consumes more than 50% cpu time.
> 
> One hot caller is exit_ptrace. If the exiting process doesn't ptrace other
> processes, kernel needn't apply for the write lock on tasklist_lock.
> 
> With below patch against kernel 2.6.35-rc5, we get more than 10% result improvement.
> 
> Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>

Acked-by: David Rientjes <rientjes@google.com>

We're guarded against ptrace_attach() because tracer->exit_state is 
non-zero at this point in the exit path.
