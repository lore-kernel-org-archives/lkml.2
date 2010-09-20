Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab0ITIe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 04:34:28 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63203 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499Ab0ITIe1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 04:34:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=mQz/z/BZKK2Ld9+FiliLURxaTYTlZmyPlzql4U+02BfelxpxoyaUaGgA1Q7nvvgpCR
         NXFjt9sHTIC2YCaIuUuEMz6JQmqh14//molofMWF+5nuEfA5sKtHdFtrRbPZ9aZPAxVG
         SZ9BqMc6IV6jh/oEbDmiBm9GP0Mdx6vZSKwmU=
MIME-Version: 1.0
In-Reply-To: <20100917115523.3f583f8d.rdunlap@xenotime.net>
References: <AANLkTintKaxaAKarDPFgpDLQMVomhThYtZecp5R5Mi62@mail.gmail.com>
	<20100917115523.3f583f8d.rdunlap@xenotime.net>
Date: Mon, 20 Sep 2010 16:34:26 +0800
Message-ID: <AANLkTimp7yk3jNKo0L=MOSpZPVgdPiy81-pAFrGqV6P9@mail.gmail.com>
Subject: Re: A simple question of sys_
From: Rofail Qu <rofail@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/18 Randy Dunlap <rdunlap@xenotime.net>:
> On Fri, 17 Sep 2010 14:58:30 +0800 Rofail Qu wrote:
>
>> How to use macro IS_ERR() ?
>>
>> It defines as,
>> ...
>> #define IS_ERR_VALUE(x) unlikely((x) >= (unsigned long)-MAX_ERRNO)
>> static inline long __must_check IS_ERR(const void *ptr)
>> {
>>       return IS_ERR_VALUE((unsigned long)ptr);
>> }
>> ...
>> so when pass x as a pointer and x>=-MAX_ERRNO (including NULL or any
>> valid address),
>> IS_ERR() will return true!
>
> Since your conclusion is false, some part of your premise must have a problem.
> Can you find it?
Got it.
thanks any way.

>
>
>> IS_ERR(x) seems to use on judge if "x" is a valid error number, right?
>
> Yes, that's what it is for.
So in kernel, a bad pointer must have saved an valid error number, right?

>
>> So in sys_execve(),
>> ...
>>         long error;
>>       char* filename;
>>
>>       filename = getname(name);
>>       error = PTR_ERR(filename);
>>       if (IS_ERR(filename))     // <== should be IS_ERR((void *)error) or other?
>>               return error;
>>       error = do_execve(filename, argv, envp, regs);
>> ...
>>
>> Where i am wrong?
>
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
