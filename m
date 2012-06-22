Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab2FVWHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 18:07:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38442 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab2FVWHp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 18:07:45 -0400
MIME-Version: 1.0
In-Reply-To: <20120622145711.d7f720cd.akpm@linux-foundation.org>
References: <20120622192413.GA5774@www.outflux.net>
	<20120622125551.269552c2.akpm@linux-foundation.org>
	<CAGXu5jLMRc3svVuPznUkUEcF2HOHRE_6b5bmL-Aiw7FtsN6zHw@mail.gmail.com>
	<20120622143435.c1ba744e.akpm@linux-foundation.org>
	<CAGXu5jJq-hZ4Q-ThdQ+KD=uGgHq1KP0_tTsefG8qkFGi8Em-qw@mail.gmail.com>
	<20120622145711.d7f720cd.akpm@linux-foundation.org>
Date: Fri, 22 Jun 2012 15:07:45 -0700
X-Google-Sender-Auth: rx7bnvLTzODvx4M-QJbm9xw9UMc
Message-ID: <CAGXu5jLOJrZTNKh=G75wP2fo-cPj_mM-Urc+4hDVvyJpiy+7Dg@mail.gmail.com>
Subject: Re: [PATCH v3] fs: introduce pipe-only dump mode suid_dumpable=3
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Rob Landley <rob@landley.net>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Doug Ledford <dledford@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Joe Korty <joe.korty@ccur.com>, David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 2:57 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 22 Jun 2012 14:51:54 -0700
> Kees Cook <keescook@chromium.org> wrote:
>
>> > And how serious is the security vulnerability, in real-world terms?
>> > Serious enough to risk this amount of bustage?
>>
>> If they're running in mode "2" and they do not have a coredump pipe
>> handler defined, local users can gain root access.
>
> But the kernel can detect this case and avoid it?  If we do that at the same
> time, we can avoid any mode=2 non-back-compatible breakage?

What? Do you mean detect if it's going to disk or to a pipe?

suid core dumps going to disk is not safe. The "mode=2" stuff was
added in an attempt to make it safe, but it has never actually be
safe. Some Linux systems with integrated crash handlers (i.e.
core_pattern with a pipe) want to catch crashes even in suid
processes, so mode=2 makes sense for them since they're handling the
core dump directly, making decisions about it, etc. However, if that
core_pattern is not a pipe, this leads to local users being able to
trick root processes into doing things to give the user root access.

mode=2 to disk _should_ break, is my point. It is not safe. Hence, my
original change to just disallow a mode=2 coredump from going to disk.
It's fine to throw it at the pipe, so leave that as-is.

-Kees

-- 
Kees Cook
Chrome OS Security
