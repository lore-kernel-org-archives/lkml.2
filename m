Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab2D3I4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 04:56:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891Ab2D3I4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 04:56:20 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20120419155211.GC22307@redhat.com>
References: <20120419155211.GC22307@redhat.com> <20120419155111.GA22299@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Gordeev <agordeev@redhat.com>,
        Chris Zankel <chris@zankel.net>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/3] cred: change keyctl_session_to_parent() to use task_work_add()
Date: Mon, 30 Apr 2012 09:56:05 +0100
Message-ID: <20914.1335776165@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> Change keyctl_session_to_parent() to use task_work_add() and
> move key_replace_session_keyring() logic into task_work->func().
> 
> Note that we do task_work_cancel() before task_work_add() to
> ensure that only one work can be pending at any time. This is
> important, we must not allow user-space to abuse the parent's
> ->task_works list.
> 
> The callback, replace_session_keyring(), checks PF_EXITING.
> I guess this is not really needed but looks better.
> 
> As a side effect, this fixes the (unlikely) race. The callers
> of key_replace_session_keyring() and keyctl_session_to_parent()
> lack the necessary barriers, the parent can miss the request.
> 
> Now we can remove task_struct->replacement_session_keyring and
> related code.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: David Howells <dhowells@redhat.com>
