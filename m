Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab2AaT0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 14:26:32 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42615 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab2AaT0a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 14:26:30 -0500
MIME-Version: 1.0
In-Reply-To: <20120125153028.17d69f6e.akpm@linux-foundation.org>
References: <20120123212115.GA29641@www.outflux.net>
	<20120125153028.17d69f6e.akpm@linux-foundation.org>
Date: Tue, 31 Jan 2012 11:26:29 -0800
X-Google-Sender-Auth: Q7I2p3JdWsZghobr1sXlDjvmB2w
Message-ID: <CAGXu5jLgPCccC1kR1swdTsojh-nEw82QbhfBNXUgOYaGudTmjw@mail.gmail.com>
Subject: Re: [PATCH v3] sysctl: control functionality of /proc/pid/mem
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Borislav Petkov <bp@alien8.de>,
        Vasiliy Kulikov <segoon@openwall.com>, Dan Ballard <dan@mindstab.net>,
        Jiri Kosina <jkosina@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        Stephen Wilson <wilsons@start.ca>,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        linux-doc@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Colin Walters <walters@verbum.org>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 3:30 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 23 Jan 2012 13:21:15 -0800
> Kees Cook <keescook@chromium.org> wrote:
>> Add the "proc_pid_mem" sysctl to control whether or not /proc/pid/mem is
>> allowed to work: 0: disabled, 1: read only, 2: read/write (default).
>
> I agree with Colin on this (he stole my line!).
>
> Overall, the patch looks really hacky and random.  I felt the same way
> as Vasily: it's easy to see how a significant number of similar (and
> hacky and random) patches could be added, resulting in a regrettable
> mess.
>
> Is there some better designed, more organized way of approaching all of
> this?  Random ideas:
>
> - A parallel /procfs-perms filesystem.  You write a number into
>  /procfs-perms/stat to affect access to /proc/stat (although why the
>  heck not just run `chmod /proc/stat'?) It's unclear how to handle
>  /proc/pid/.  Perhaps literally have a /procfs-perms/pid/ directory.

This seems like too much overhead to me.

> - Make tasks inherit their /proc/pid/* permissions across fork, do a
>  chmod /proc/1/whatever in initscripts.

This is actually pretty interesting. I think as long as it only
allowed the _reduction_ of access. I don't want a process to open up
access, just restrict it further. It does make me wonder what the
side-effects would be, though. Dropping user r/w perms to things for
non-DAC_OVERRIDE processes would be ... weird.

-Kees

-- 
Kees Cook
ChromeOS Security
