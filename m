Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759566Ab2ILOon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:44:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759456Ab2ILOol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:44:41 -0400
Date: Wed, 12 Sep 2012 16:45:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] uprobes: Xol should send SIGTRAP if X86_EFLAGS_TF
	was set
Message-ID: <20120912144532.GA1786@redhat.com>
References: <20120903152525.GA9028@redhat.com> <20120903152616.GA9081@redhat.com> <20120912120857.GA9582@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120912120857.GA9582@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12, Srikar Dronamraju wrote:
>
> * Oleg Nesterov <oleg@redhat.com> [2012-09-03 17:26:16]:
>
> > Note: send_sig(SIGTRAP) is not actually right, we need send_sigtrap().
>
> Are you pointing to the info field not being filled? or are there other
> problems?

Yes.

Also, I am not sure but I feel we should move this into generic code
somehow. We will see.

> > But this needs more changes, handle_swbp() does the same and this is
> > equally wrong.
>
> send_sigtrap() is arch specific and defined for only few archs.
> we would have to force.

Yes, but we have user_single_step_siginfo(), probably this is enough.

> But these are not related to the patch.

Agreed, lets do this later.

> Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Thanks!

Oleg.

