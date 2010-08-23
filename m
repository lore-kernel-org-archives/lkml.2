Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab0HWXbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 19:31:53 -0400
Received: from smtp-out.google.com ([74.125.121.35]:23370 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab0HWXbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 19:31:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=pC1mxs/nn4wS6C7vsnMTR3IkocrSTzDEzFUAoa3h4RvvXHybua0fnQU5aQBC9pPa2u
         gMw9XMn6o2RNfpr4A0Cw==
MIME-Version: 1.0
In-Reply-To: <20100811054814.GC8743@ghc17.ghc.andrew.cmu.edu>
References: <20100730235649.GA22644@ghc17.ghc.andrew.cmu.edu>
	<20100811054604.GA8743@ghc17.ghc.andrew.cmu.edu>
	<20100811054814.GC8743@ghc17.ghc.andrew.cmu.edu>
Date: Mon, 23 Aug 2010 16:31:47 -0700
Message-ID: <AANLkTind=V+V8vz1PGWiB8bCGVmfPJgC1q_XRmi5t_Eq@mail.gmail.com>
Subject: Re: [PATCH v5 2/3] cgroups: add can_attach callback for checking all
 threads in a group
From: Paul Menage <menage@google.com>
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        akpm@linux-foundation.org, ebiederm@xmission.com, lizf@cn.fujitsu.com,
        matthltc@us.ibm.com, oleg@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 10:48 PM, Ben Blum <bblum@andrew.cmu.edu> wrote:
>
> Add cgroup wrapper for safely calling can_attach on all threads in a threadgroup
>
> From: Ben Blum <bblum@andrew.cmu.edu>
>
> This patch adds a function cgroup_can_attach_per_thread which handles iterating
> over each thread in a threadgroup safely with respect to the invariants that
> will be used in cgroup_attach_proc. Also, subsystems whose can_attach calls
> require per-thread validation are modified to use the per_thread wrapper to
> avoid duplicating cgroup-internal code.
>
> This is a pre-patch for cgroup-procs-writable.patch.
>
> Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>

Acked-by: Paul Menage <menage@google.com>

Some of the can_attach() methods could be simplified slightly by
directly returning the result of cgroup_can_attach_per_thread()

Paul
