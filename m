Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab2FMPqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 11:46:53 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56150 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab2FMPqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 11:46:52 -0400
MIME-Version: 1.0
In-Reply-To: <20120612161946.GA11244@redhat.com>
References: <1338332348-3469-1-git-send-email-filbranden@gmail.com>
	<1339464499-10270-2-git-send-email-filbranden@gmail.com>
	<20120612161946.GA11244@redhat.com>
Date: Wed, 13 Jun 2012 11:46:51 -0400
Message-ID: <CABfYdSpnAB6mHWSjy91wvUB91vb74a1JG=TVxKh4XwAvKqeKiQ@mail.gmail.com>
Subject: Re: [PATCHv2 1/1] prctl: move pdeath_signal from task_struct to signal_struct
From: Albert Cahalan <acahalan@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Filipe Brandenburger <filbranden@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 12:19 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 06/11, Filipe Brandenburger wrote:

> However. This code is very, very old. I simply do not know if we can
> change the current behaviour or not. In particular, Albert Cahalan
> didn't like this change when it was last discussed because it can
> break his application.
...
>> Documentation clearly states that PR_SET_PDEATHSIG and PR_GET_PDEATHSIG should
>> act on processes, in particular case #1 is very counter intuitive because the
>> child process should not care whether the parent is multi-threaded or not.

You are assuming that the child and parent are normal separate
applications, developed by separate people, with one just being
run by the other. That is actually the odd case AFAIK, because
why then would there be reason to care about parent death?
The more normal case IMHO is that the child and parent are
deeply aware of each other. Most likely they are the same program.

In my case I have an in-process emulator, kind of like valgrind,
that uses real threads for accuracy and performance. It makes
extra threads for monitoring and control. These extra threads
keep an eye on the app being examined; obviously none of this
would work if the death signal were not per-thread.

Fix the documentation to match reality, then add a per-process one
if there is any use for it. I don't think I've ever seen use for a
per-process death signal, so perhaps it shouldn't be added even
though it does make sense.
