Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab2DTIpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 04:45:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab2DTIpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 04:45:45 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20120419231543.GD15828@redhat.com>
References: <20120419231543.GD15828@redhat.com> <20120419231431.GA15820@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Gordeev <agordeev@redhat.com>,
        Chris Zankel <chris@zankel.net>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Kuo <rkuo@codeaurora.org>, Tejun Heo <tj@kernel.org>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 4/6] keys: change keyctl_session_to_parent() to use task_work_add()
Date: Fri, 20 Apr 2012 09:45:16 +0100
Message-ID: <10220.1334911516@redhat.com>
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
