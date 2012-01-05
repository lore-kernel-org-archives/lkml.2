Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623Ab2AETgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 14:36:14 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40960 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932545Ab2AETgM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 14:36:12 -0500
MIME-Version: 1.0
In-Reply-To: <20120105091704.GB3249@elte.hu>
References: <20120104201800.GA2587@www.outflux.net>
	<20120105091704.GB3249@elte.hu>
Date: Thu, 5 Jan 2012 11:36:11 -0800
X-Google-Sender-Auth: XIspUIDd3G1Qr40Cm8JqJyzoCdw
Message-ID: <CAGXu5jJ=D1pKCZ8=1-WGkm0witNEH9Ux01+1BJyZKC_DAX00aA@mail.gmail.com>
Subject: Re: [PATCH v2012.1] fs: symlink restrictions on sticky directories
From: Kees Cook <keescook@chromium.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Federica Teodori <federica.teodori@googlemail.com>,
        Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Paris <eparis@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Dan Rosenberg <drosenberg@vsecurity.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 1:17 AM, Ingo Molnar <mingo@elte.hu> wrote:
> * Kees Cook <keescook@chromium.org> wrote:
>
>> @@ -1495,6 +1496,15 @@ static struct ctl_table fs_table[] = {
>>  #endif
>>  #endif
>>       {
>> +             .procname       = "protected_sticky_symlinks",
>> +             .data           = &protected_sticky_symlinks,
>> +             .maxlen         = sizeof(int),
>> +             .mode           = 0644,
>> +             .proc_handler   = proc_dointvec_minmax,
>> +             .extra1         = &zero,
>> +             .extra2         = &one,
>> +     },
>
> Small detail:
>
> Might make sense to change the .mode to 0600, to make it harder
> for unprivileged attack code to guess whether this protection
> (and the resulting audit warning to the administrator) is
> enabled on a system or not.

Sure, I have no problem with that. In addition to this change, what's
the best next step for this patch?

Thanks,

-Kees

-- 
Kees Cook
ChromeOS Security
