Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab2BSBgm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 20:36:42 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:47710 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754237Ab2BSBgi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 20:36:38 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of keescook@google.com designates 10.60.21.134 as permitted sender) smtp.mail=keescook@google.com; dkim=pass header.i=keescook@google.com
MIME-Version: 1.0
In-Reply-To: <20120218205626.GA26880@joi.lan>
References: <20120218193857.GA30985@www.outflux.net>
	<20120218205626.GA26880@joi.lan>
Date: Sat, 18 Feb 2012 17:36:36 -0800
X-Google-Sender-Auth: DdMW7DJAEjtmXdSOJFhmtrsJr6E
Message-ID: <CAGXu5jJQVWS60m5W1-OvDCDixe=kVU2HxPP1C3zNCVgWcXzdDA@mail.gmail.com>
Subject: Re: [PATCH] fs: hardlink creation restrictions
From: Kees Cook <keescook@chromium.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
        linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 18, 2012 at 12:56 PM, Marcin Slusarz
<marcin.slusarz@gmail.com> wrote:
> On Sat, Feb 18, 2012 at 11:38:57AM -0800, Kees Cook wrote:
>> @@ -3052,6 +3119,9 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
>>       error = mnt_want_write(new_path.mnt);
>>       if (error)
>>               goto out_dput;
>> +     error = may_linkat(&old_path);
>> +     if (error)
>> +             goto out_dput;
>>       error = security_path_link(old_path.dentry, &new_path, new_dentry);
>>       if (error)
>>               goto out_drop_write;
>
> You should give up write access after check failure (i.e. goto out_drop_write).

Ah! Thanks, yes, good catch. I will move the check before mnt_want_write().

-Kees

-- 
Kees Cook
ChromeOS Security
