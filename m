Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab2DOUsG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 16:48:06 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63184 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab2DOUsD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 16:48:03 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <12563.1228544795@turing-police.cc.vt.edu>
References: <493A01E0.1070705@gmail.com> <200812061404.EJG35994.MOJOFQFOLFHtVS@I-love.SAKURA.ne.jp>
 <12563.1228544795@turing-police.cc.vt.edu>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Mon, 16 Apr 2012 08:47:42 +1200
Message-ID: <CAKgNAkh+mnOW8ko7NRHeRJqLdX0_HT-Uzm2jnMeVzSe=E2a0JQ@mail.gmail.com>
Subject: Re: MAC and pam_nologin (was Re: man-pages-3.15 is released)
To: Valdis.Kletnieks@vt.edu
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        mtk.manpages@googlemail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tetsuo Handa,

On Sat, Dec 6, 2008 at 7:26 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Sat, 06 Dec 2008 14:04:07 +0900, Tetsuo Handa said:
>
> (Not really a LSM or kernel issue, and I think mtk.man does kernel
> manpages only.  At least on my Fedora and RedHat systems, the 'login' manpage
> comes from util-linux, so any manpage fixes would go via that route).
>
>> But this description becomes inaccurate when MAC (e.g. SELinux) is enabled.
>>
>> MAC can deny open("/etc/nologin", O_RDONLY) by root user. Thus,
>>
>>   # ln /etc/shadow /etc/nologin
>>
>> will create /etc/nologin which is *not readable* by login(1).
>> As a result, non-root user's logins are permitted while /etc/nologin *exists*
>>
>> I guess pam_nologin is using a code like
>>
>>   fp = fopen("/etc/nologin", "r");
>>   if (fp)
>>      /* print the contents of /etc/nologin and reject login request. */
>
> Rather than guessing, maybe a check of what the source code actually *does*
> would be better?
>
>> So, I think either one of below modifications is needed.
>>
>> (1) Change the description of manpage like
>>
>>   If the file /etc/nologin *is readable*, login (1) will allow access only to
>>   root. Other users will be shown the contents of this file and their logins
>>   will be refused.
>>
>> (2) Change the code of pam_nologin like
>>
>>   fd = open("/etc/nologin", O_RDONLY);
>>   if (fd != EOF || errno != ENOENT)
>>      /* print the contents of /etc/nologin and reject login request. */
>
> (3) Recognize that a sysadmin who intentionally goes and creates a
> /etc/nologin via insane means deserves the insane results.  You have to
> go out of your way to actually create a case where the distinction between
> "exists" and "is readable" matters.
>
> Having said that, we probably *should* fix 'man login' to say 'is readable'.

I added the words "and is readable" to nologin.5.

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
