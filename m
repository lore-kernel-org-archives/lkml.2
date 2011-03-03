Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206Ab1CCRse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 12:48:34 -0500
Received: from smtp-out.google.com ([74.125.121.67]:14967 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130Ab1CCRsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 12:48:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=oN6/CKoY1SrqYaet1uewZ+PFDKeEJst0YE/OpuXhEdbSzmGX18KK6P/8jltQ/CPHZW
         OkrM1yA4zbQNzVNxKXAQ==
MIME-Version: 1.0
In-Reply-To: <20110216192200.GA11980@ghc17.ghc.andrew.cmu.edu>
References: <20110208013542.GC31569@ghc17.ghc.andrew.cmu.edu>
 <20110208013950.GF31569@ghc17.ghc.andrew.cmu.edu> <20110216192200.GA11980@ghc17.ghc.andrew.cmu.edu>
From: Paul Menage <menage@google.com>
Date: Thu, 3 Mar 2011 09:48:09 -0800
Message-ID: <AANLkTinKTqBnjLKkv93UxyWoPL-2vyXP=LUvRz8JTC2K@mail.gmail.com>
Subject: Re: [PATCH v8 4/3] cgroups: use flex_array in attach_proc
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        akpm@linux-foundation.org, ebiederm@xmission.com, lizf@cn.fujitsu.com,
        matthltc@us.ibm.com, oleg@redhat.com,
        David Rientjes <rientjes@google.com>, Miao Xie <miaox@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 11:22 AM, Ben Blum <bblum@andrew.cmu.edu> wrote:
> Convert cgroup_attach_proc to use flex_array.
>
> From: Ben Blum <bblum@andrew.cmu.edu>
>
> The cgroup_attach_proc implementation requires a pre-allocated array to store
> task pointers to atomically move a thread-group, but asking for a monolithic
> array with kmalloc() may be unreliable for very large groups. Using flex_array
> provides the same functionality with less risk of failure.
>
> This is a post-patch for cgroup-procs-write.patch.
>
> Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>

Reviewed-by: Paul Menage <menage@google.com>

Looks fine from a correctness point of view, but I'd be inclined to
reduce the verbosity - rather than

tsk = flex_array_get_ptr(group, i);
BUG_ON(tsk == NULL);
retval = ss->can_attach_task(cgrp, tsk);

I'd just have

retval = ss->can_attach_task(cgrp, flex_array_get_ptr(group, i));

I don't think you need to be so defensive about flex_array's behaviour.

Paul
