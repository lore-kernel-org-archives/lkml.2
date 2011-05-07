Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab1EGGW7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 02:22:59 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:59975 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab1EGGWx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 02:22:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=JnHr1Vhh0Aevx/5ct2QBmPaeuyU9oV27KkVNAOV6rX/IgeQqWY0dIbDOUQLR7U+Wr0
         EOM1aDKHAZHsNg/LNvNb9ehSmwaJYqkNb47FcrvD6ICw96ATVMh1HaOWE9jFch2vbdxB
         eJHo/zC5Ytx7oP7hlRKyp+BymAdAlL7sa5+fo=
MIME-Version: 1.0
In-Reply-To: <1304748394.2821.654.camel@edumazet-laptop>
References: <1304743740-3405-1-git-send-email-xiaosuo@gmail.com> <1304748394.2821.654.camel@edumazet-laptop>
From: Changli Gao <xiaosuo@gmail.com>
Date: Sat, 7 May 2011 14:22:33 +0800
Message-ID: <BANLkTi=tZf1uQig8A-WiXUpSWcuqaqV=fg@mail.gmail.com>
Subject: Re: [PATCH] fs: add FD_CLOFORK and O_CLOFORK
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <matthew@wil.cx>,
        Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 7, 2011 at 2:06 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le samedi 07 mai 2011 à 12:49 +0800, Changli Gao a écrit :
>
>>
>>       for (i = open_files; i != 0; i--) {
>>               struct file *f = *old_fds++;
>>               if (f) {
>> -                     get_file(f);
>> +                     if (FD_ISSET(open_files - i, new_fdt->close_on_fork)) {
>> +                             FD_CLR(open_files - i, new_fdt->open_fds);
>> +                             f = NULL;
>> +                     } else {
>> +                             get_file(f);
>> +                     }
>>               } else {
>>                       /*
>
> You should change the main loop to
>
> for (i = 0; i < open_files; i++) {
>        struct file *f = *old_fds++;
>
>        if (f && FD_ISSET(i, new_fdt->close_on_fork))
>                f = NULL;
>        if (f)
>                get_file(f);
>        else
>                FD_CLR(i, new_fdt->open_fds)
>        rcu_assign_pointer(*new_fds++, f);
> }

It seems more clear. Thanks.

BTW: I will work on F_CLOSFD after this patch accepted. It is useful
to close all the opened file descriptors when programing a daemon.

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
