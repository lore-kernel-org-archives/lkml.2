Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab2AUJLK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 04:11:10 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34618 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab2AUJLD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 04:11:03 -0500
MIME-Version: 1.0
In-Reply-To: <20120121090342.GD32134@elte.hu>
References: <20120121084317.GA30541@www.outflux.net>
	<20120121090342.GD32134@elte.hu>
Date: Sat, 21 Jan 2012 01:11:01 -0800
X-Google-Sender-Auth: XSntp1bfS4jXp1LhCrYvAb1se9c
Message-ID: <CAGXu5jJoLB-hBUpYtBS78MmDbm0Xc7QykmBDb15tt22crydB5w@mail.gmail.com>
Subject: Re: [PATCH] sysctl: control functionality of /proc/pid/mem
From: Kees Cook <keescook@chromium.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Vasiliy Kulikov <segoon@openwall.com>,
        Dan Ballard <dan@mindstab.net>, Jiri Kosina <jkosina@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>, Stephen Wilson <wilsons@start.ca>,
        David Rientjes <rientjes@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        linux-doc@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 21, 2012 at 1:03 AM, Ingo Molnar <mingo@elte.hu> wrote:
> * Kees Cook <keescook@chromium.org> wrote:
>
>> @@ -702,6 +704,9 @@ static int mem_open(struct inode* inode, struct file* file)
>>       struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
>>       struct mm_struct *mm;
>>
>> +     if (sysctl_proc_pid_mem < 1)
>> +             return -EACCES;
>
> This looks like an unprivileged user-space triggerable memory
> leak DoS. The task reference is already acquired at that point.

Ah, good catch; thanks. I'll respin.

-Kees

-- 
Kees Cook
ChromeOS Security
