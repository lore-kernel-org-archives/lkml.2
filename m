Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab2DOXrL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 19:47:11 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:47628 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab2DOXrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 19:47:10 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwpts0X=V67+wUchJN9Bgjh17eZJqOo0Y0oc2Mzbfa7QA@mail.gmail.com>
References: <20120414235238.GA11131@redhat.com> <CA+55aFxJykAy4=9WVOnUOy1PUBYLmPy9mJmydoYZpQEbSkfvJQ@mail.gmail.com>
 <20120415223808.GA26214@redhat.com> <CA+55aFwpts0X=V67+wUchJN9Bgjh17eZJqOo0Y0oc2Mzbfa7QA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 15 Apr 2012 16:46:48 -0700
X-Google-Sender-Auth: q5IUXw9Mbf2wdUXtmnl4264VUcE
Message-ID: <CA+55aFzeLqBMJ_tGyKh7EJhqWwPkD7DfggZ=NDmxwi3gYNjkdA@mail.gmail.com>
Subject: Re: ptrace && fpu_lazy_restore
To: Oleg Nesterov <oleg@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Chuck Ebbert <chuckebbert.lk@gmail.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2012 at 4:42 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> That one is done by design. That fpu_counter=0 in copy_thread() is
> there explicitly to avoid the problem. Although it's possible that we
> should reset last_cpu instead. However, that line was actually added
> before the lazy thing - see commit cea20ca3f318.

Put another way: I do think it would be a good idea to do the "reset
last_cpu" in copy_thread() too. It doesn't really cost us anything,
and it's cleaner to always just make sure that last_cpu is "valid"
(even if the fpu_owner_task is *also* used to invalidate it, and even
if we never use the lazy restore if fpu_counter is zero and thus
fpu.preload isn't set).

                    Linus
