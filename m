Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344Ab0K2ISb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 03:18:31 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:44550 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab0K2ISb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 03:18:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:cc:content-type
         :content-transfer-encoding;
        b=PFGhMKPbmd7rdYPgcsNU6OjpWzFj35bY7jh5hb0t2q3kHXPoeRX9l4fup4ZWywCqcB
         /V7CN//lJKwPn5fIsdvbnhoBAn7zwS2rqyva5b/YvhBk+yGLs2cHaBghCDvmXmHy5bu4
         FIP0yeGjyianBwQS7u59kfDAOxeONV+nmouiQ=
MIME-Version: 1.0
In-Reply-To: <20101129081619.GD5218@cr0.nay.redhat.com>
References: <AANLkTimewZ4QhxzL2vOYYV85pegy8Fu6Rb4XUAPqGUXS@mail.gmail.com> <20101129081619.GD5218@cr0.nay.redhat.com>
From: microcai <microcai@fedoraproject.org>
Date: Mon, 29 Nov 2010 16:18:09 +0800
X-Google-Sender-Auth: T3VPn86fDzYw9Z1T09k1CTrBzo8
Message-ID: <AANLkTi=c4THHSaBCmuxfTZ4k1WUGVkzJzCJXMgX82fzX@mail.gmail.com>
Subject: Re: [PATCH] Built kernel without -O2 option
Cc: Hui Zhu <teawater@gmail.com>, linux-kernel@vger.kernel.org,
        gdb@sourceware.org, hellogcc@freelists.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/29 Américo Wang <xiyou.wangcong@gmail.com>:
> On Mon, Nov 29, 2010 at 11:56:15AM +0800, Hui Zhu wrote:
>>Hi,
>>
>>Now, there are a lot of ways to debug the Linux kernel with GDB, like
>>qemu, kgtp or kgdb and so on.
>>But the developer more like add a printk. It have a lot of reason, a big one is:
>>(gdb) p ret
>>$3 = <value optimized out>
>>And the code execution order is not right.
>>
>>This is becuase the Kernel is bult with gcc -O2.  Gcc will not
>>generate enough debug message with file with -O2.
>>So GDB cannot work very well with Linux kernel.
>>
>>So I make a patch that add a option in "Kernel hacking" called "Close
>>GCC optimization".  It will make kernel be built without -O2.
>>
>>I built and use it in i386 and x86_64.  I will try to make it OK in other arch.
>>
>
> The problem is that some functions _have to_ be inlined and gcc without -O2
> doesn't inline them. Have check all the cases? I doubt.
>
> Also, what is size of vmlinux before applying your patch and after that?
> Does it increase too much?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
