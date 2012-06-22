Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759302Ab2FVW0w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 18:26:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34230 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758981Ab2FVW0Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 18:26:25 -0400
MIME-Version: 1.0
In-Reply-To: <20120622152029.638ade70.akpm@linux-foundation.org>
References: <20120622192413.GA5774@www.outflux.net>
	<20120622125551.269552c2.akpm@linux-foundation.org>
	<CAGXu5jLMRc3svVuPznUkUEcF2HOHRE_6b5bmL-Aiw7FtsN6zHw@mail.gmail.com>
	<20120622143435.c1ba744e.akpm@linux-foundation.org>
	<CAGXu5jJq-hZ4Q-ThdQ+KD=uGgHq1KP0_tTsefG8qkFGi8Em-qw@mail.gmail.com>
	<20120622145711.d7f720cd.akpm@linux-foundation.org>
	<CAGXu5jLOJrZTNKh=G75wP2fo-cPj_mM-Urc+4hDVvyJpiy+7Dg@mail.gmail.com>
	<20120622152029.638ade70.akpm@linux-foundation.org>
Date: Fri, 22 Jun 2012 15:26:24 -0700
X-Google-Sender-Auth: jxz3GxzbRaHyqbBgKBFtuHGACEc
Message-ID: <CAGXu5j+jhitULgFd_9VmRgcShVa9d+6pqT2hyDu7LEmc_BHDew@mail.gmail.com>
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

On Fri, Jun 22, 2012 at 3:20 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 22 Jun 2012 15:07:45 -0700
> Kees Cook <keescook@chromium.org> wrote:
>
>> mode=2 to disk _should_ break, is my point.
>
> And my point is that we should at least tell people that we broke it.
> I don't believe that returning an EINVAL from the write() is
> sufficient.  Because it introduces a high risk that people will run
> misconfigured systems for lengthy periods and it will cause them to
> have to do a *lot* of work once they discover that their system is
> misbehaving.
>
> So if we really really must instabreak back-compatibility, we should
> shout loudly into syslog about it: tell people that their system is
> broken and tell them what to do about it.
>
> And we should explain and justify this extraordinary action in the
> patch changelog.

Okay, sounds good. Should mode 3 added with mode 2 removed, or just
drop the dangerous behavior from mode 2? I will be loud in either
situation (e.g. with mode 3, setting mode 2 shouts, or when attempt to
write to disk in mode 2, shout).

-Kees

-- 
Kees Cook
Chrome OS Security
