Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648Ab0FBUbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 16:31:47 -0400
Received: from smtp-out.google.com ([74.125.121.35]:32147 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758638Ab0FBUbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 16:31:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=v8OATVw0t4moyvz5bFKsKN4lHo3gl/3e/lbkh/YmSLM5W656Rkde/q1XEJejAfl6X
	FB9j5ceqMmvE9DT8aLWCw==
MIME-Version: 1.0
In-Reply-To: <20100602202048.GB28663@redhat.com>
References: <20100530013002.GA762@ghc01.ghc.andrew.cmu.edu>
	<20100530013303.GC762@ghc01.ghc.andrew.cmu.edu>
	<20100531175242.GA14691@redhat.com>
	<20100531180446.GA16249@redhat.com>
	<AANLkTimcrX0TjzDMNJdubR92pAO4IPATbVpyvvVt0qIV@mail.gmail.com>
	<20100602140659.GA5324@redhat.com>
	<AANLkTin-T6ij3xf0ceGoCamwcoayxyf0GdAKY6yXDMVl@mail.gmail.com>
	<20100602202048.GB28663@redhat.com>
Date: Wed, 2 Jun 2010 13:31:41 -0700
Message-ID: <AANLkTimrJFiidM8BlUNvmzfapUAv8369R9PYnTscasEf@mail.gmail.com>
Subject: Re: [RFC] [PATCH 2/2] cgroups: make procs file writable
From: Paul Menage <menage@google.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ben Blum <bblum@andrew.cmu.edu>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 2, 2010 at 1:20 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> Yes sure. The main thread can exit via sys_exit(), this doesn't affect
> the thread group. Of course, I am not saying this is common practice,
> perhaps no "important" app does this.

This check has been in cgroups for quite a while and no-one's
complained so far...

> But I still can't understand why we can't just remove it. Both
> cgroup_attach_task() and cgroup_attach_proc() should handle the
> possible races correctly anyway.

The "it" that you're proposing to remove is in fact the code that
handles those races.

Anyway, I think this issue is orthogonal to the movability of entire
processes - with Ben's patch, an exited-but-not-reaped group leader is
immovable either via "tasks" or "cgroup.procs". Changing the race
condition handling to allow such movement would be a separate issue.

Paul

Paul
