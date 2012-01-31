Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab2AaTWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 14:22:44 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47866 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab2AaTWm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 14:22:42 -0500
MIME-Version: 1.0
In-Reply-To: <20120124115104.GA5743@albatros>
References: <20120123212115.GA29641@www.outflux.net>
	<20120124110332.GA4770@albatros>
	<CACVxJT95OjBkqh01AGVLVXDEw3YNaEcCNptgM9kbb47AG5C7zg@mail.gmail.com>
	<20120124115104.GA5743@albatros>
Date: Tue, 31 Jan 2012 11:22:42 -0800
X-Google-Sender-Auth: XC3tGKIG5-OG71JavzrLaiIS_bo
Message-ID: <CAGXu5jJMRRXFKi9XH9BBupxYYjq0SoxUxrmyYiB2H8h0QbN=UA@mail.gmail.com>
Subject: Re: [PATCH v3] sysctl: control functionality of /proc/pid/mem
From: Kees Cook <keescook@chromium.org>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Borislav Petkov <bp@alien8.de>,
        Dan Ballard <dan@mindstab.net>, Jiri Kosina <jkosina@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>, Stephen Wilson <wilsons@start.ca>,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 3:51 AM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> On Tue, Jan 24, 2012 at 13:12 +0200, Alexey Dobriyan wrote:
>> On 1/24/12, Vasiliy Kulikov <segoon@openwall.com> wrote:
>> >> +          .procname       = "proc_pid_mem",
>> >> +          .data           = &sysctl_proc_pid_mem,
>> >> +          .maxlen         = sizeof(int),
>> >> +          .mode           = 0644,
>> >> +          .proc_handler   = proc_dointvec_minmax,
>> >> +          .extra1         = &zero,
>> >> +          .extra2         = &two,
>> >> +  },
>>
>> >E.g. moving all such stuff to some sysctl group, not bloating
>> > kernel.*.
>>
>> Ehh.
>> How bloat is measured in this case?
>
> Do we want to add such sort of sysctls "from time to time" when we
> consider one or another feature as deprecated?  If yes, I'd group them
> somehow, e.g. by introducing subdirectory inside of kernel.
>
> Btw, kernel sysctl dir contains all sort of stuff which goes to "kernel"
> as if it is "etc".  It already contains ftrace, perf, printk, scheduler,
> ipc.  IMHO plain kernel hierarchy is not profitable in the long term.

Yeah, after reconsidering this, this sysctl is not the right approach.

-Kees

-- 
Kees Cook
ChromeOS Security
