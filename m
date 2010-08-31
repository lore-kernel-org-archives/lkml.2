Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab0HaOfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 10:35:09 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60787 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757414Ab0HaOfH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 10:35:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=IVytnrPRtMOUclSA4DObHGf0Lyt467BJe6BYP8DIgTJJksTo/jy5MNoY6g/YHt3Ogu
         BvlbN7ZQ5cHzJxf34jfNCXADenltNEgCD7IEGjghkVgbTzwQNMeMKkvrLS1abZZYNayd
         mEZuBGyXrXXAYTnY4+isG7oKLnUsp/9dEli6A=
MIME-Version: 1.0
In-Reply-To: <20100831143003.GA15001@merkur.ravnborg.org>
References: <1283189270-7274-1-git-send-email-namhyung@gmail.com>
 <1283189270-7274-2-git-send-email-namhyung@gmail.com> <20100830190330.GB12921@merkur.ravnborg.org>
 <AANLkTimysA_CmWVBOntV9bzUBy9Vbhi1MtUJQJAHbQxq@mail.gmail.com> <20100831143003.GA15001@merkur.ravnborg.org>
From: Namhyung Kim <namhyung@gmail.com>
Date: Tue, 31 Aug 2010 23:34:46 +0900
Message-ID: <AANLkTim1Wkrjx9VWwCuf=6O0hJPkWT5oT_-WxEi78EZD@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] init: add sys-wrapper.h
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 23:30, Sam Ravnborg <sam@ravnborg.org> wrote:
>>
>> /*
>>  * wrappers for various syscalls for use in the init code
>>  *
>>  * Copyright (C) 2010  Namhyung Kim <namhyung@gmail.com>
>>  *
>>  * This file is released under the GPLv2.
>>  */
>>
>> #include <linux/syscalls.h>
>> #include <linux/dirent.h>
>> #include <linux/types.h>
>> #include <linux/fs.h>
>>
>> #include <asm/uaccess.h>
>>
>
> Good.
> Except that we usually recommend to include files from include/linux
> if thye exist rather than asm/xxx
>
> So use: #include <linux/uaccess.h>
>

OK. No problem. :-)


>
>>
>> >> +
>> >> +#define kern_sys_call(call, ...)             \
>> >> +({                                           \
>> >> +     long result;                            \
>> >> +     mm_segment_t old_fs = get_fs();         \
>> >> +     set_fs(KERNEL_DS);                      \
>> >> +     result = call(__VA_ARGS__);             \
>> >> +     set_fs(old_fs);                         \
>> >> +     result;                                 \
>> >> +})
>> >> +
>> >
>> > Personal preference...
>> > Replace kern_ with kernel_ all over.
>> >
>>
>> Is this just your preference or general tendency?
> I asked git:
> $ git grep kern_ | wc -l
> 962
> $ git grep kernel_ | wc -l
> 6361
>
> There seems to be preference for kernel_
>

I see. Will change it.
Thanks.


-- 
Regards,
Namhyung Kim
