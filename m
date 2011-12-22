Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab1LVPWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 10:22:01 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:37926 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab1LVPWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 10:22:00 -0500
MIME-Version: 1.0
In-Reply-To: <20111222151529.GA1388@redhat.com>
References: <20111222001800.GL9213@google.com>
	<20111222001939.GM9213@google.com>
	<20111222004629.GO9213@google.com>
	<20111221170919.f7d49fc6.akpm@linux-foundation.org>
	<20111222012312.GP9213@google.com>
	<20111222151529.GA1388@redhat.com>
Date: Thu, 22 Dec 2011 07:21:59 -0800
X-Google-Sender-Auth: jFXpcIoZplmuO7v7t7llcQDykF4
Message-ID: <CAOS58YNEkv4Nj_B6fGeir3sbGd_zAwdwYfgUC9BdD8b7wmOhKA@mail.gmail.com>
Subject: Re: [PATCH UPDATED 2/2] mempool: fix first round failure behavior
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Dec 22, 2011 at 7:15 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> For blkio to use these percpu mempool, I guess we shall have to change this
> notion that an allocated object from mempool is returned to the pool soon.
> We might not be returning these per cpu stat objects to mempool for a very
> long time (These will be returned to pool only when somebody deletes the
> cgroup).

I'm almost done with it and it can behave as allocation buffer which
is filled from more permissible context and consumed in more
constricted one and async filling kicks the waiting allocator so I
think we should be fine.

Thanks.

-- 
tejun
