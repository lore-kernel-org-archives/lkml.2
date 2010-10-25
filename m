Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265Ab0JYRsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 13:48:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522Ab0JYRst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 13:48:49 -0400
Date: Mon, 25 Oct 2010 19:42:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [resend][PATCH 3/4] move cred_guard_mutex from task_struct to
	signal_struct
Message-ID: <20101025174220.GA21375@redhat.com>
References: <20101025122538.9167.A69D9226@jp.fujitsu.com> <20101025122801.9170.A69D9226@jp.fujitsu.com> <20101025172657.A9EC9C9E3C@blackie.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101025172657.A9EC9C9E3C@blackie.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25, Roland McGrath wrote:
>
> This has my ACK if Oleg doesn't see any problems.

I believe the patch is fine (it already has my reviewed-by).

Except: I am not sure about -stable. At least, this patch should
not go into the <2.6.35 kernels, it relies on misc changes which
changed the scope of task->signal. Before 2.6.35 almost any user
of ->cred_guard_mutex can race with exit and hit ->signal == NULL.

Oleg.

