Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571Ab0FBRy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 13:54:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932449Ab0FBRyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 13:54:55 -0400
Date: Wed, 2 Jun 2010 19:53:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] oom: Make coredump interruptible
Message-ID: <20100602175325.GA16474@redhat.com>
References: <20100601093951.2430.A69D9226@jp.fujitsu.com> <20100601201843.GA20732@redhat.com> <20100602221805.F524.A69D9226@jp.fujitsu.com> <20100602154210.GA9622@redhat.com> <20100602172956.5A3E34A491@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100602172956.5A3E34A491@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02, Roland McGrath wrote:
>
> Why not just test TIF_MEMDIE?

Because it is per-thread.

when select_bad_process() finds the task P to kill it can participate
in the core dump (sleep in exit_mm), but we should somehow inform the
thread which actually dumps the core: P->mm->core_state->dumper.

Well, we can use TIF_MEMDIE if we chose the right thread, I think.
But perhaps mm->flags |= MMF_OOM is better, it can have other user.
I dunno.

Oleg.

