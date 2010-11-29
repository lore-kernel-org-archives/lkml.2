Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab0K2CWK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 21:22:10 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57680 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474Ab0K2CWI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 21:22:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=YY8UQSVDJ28OxhEVJeTXjlQatPVfQov8XETzP456WGe9K2xlTenu+XkFsG2IW4n5vV
         TU4NE1u6Tn8vi5Q04O0b93E5r/cGvqZ1a9LA9pVBtp4k0L0JfB5iou82Sqes9qDcFRMl
         /287r0s7YTtThL/Tu4L9FCiCxYViFY/G8DXcg=
MIME-Version: 1.0
In-Reply-To: <4CF30B46.4000203@pavlinux.ru>
References: <4CF30B46.4000203@pavlinux.ru>
From: microcai <microcai@fedoraproject.org>
Date: Mon, 29 Nov 2010 10:21:47 +0800
X-Google-Sender-Auth: hwU7dX8fLWcF9Nw-ZXUclh0Usv8
Message-ID: <AANLkTi=ACufPs18wia8MYpjp9nDnYJgSmw018P6_WhR9@mail.gmail.com>
Subject: Re: [PATCH] Repalce strncmp by memcmp
To: pavel@pavlinux.ru
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/29 Pavel Vasilyev <pavel@pavlinux.ru>:
>
>    This patch replace all strncmp(a, b, c) by  memcmp(a, b, c).
>
> I test on x86_64 (AMD Opteron 285).
>
> #include <string.h>
> char *A = "0000";
> void test_memcmp(void) {
>        memcmp(A, "TEST", 4);
> }
> void test_strn(void) {
>        strncmp(A, "TEST", 4);
> }
> # gcc -c -O2 test.c
> # objdump -d test.o
> ...
>
> 0000000000000020 <test_strncmp>:
>  20:   f3 c3                   repz retq
>  22:   66 66 66 66 66 2e 0f    data32 data32 data32 data32 nopw
> %cs:0x0(%rax,%rax,1)
>  29:   1f 84 00 00 00 00 00
>
> 0000000000000030 <test_memcmp>:
>  30:   f3 c3                   repz retq
>
> Wow, minus  one commad :)
>

Wow, good, I test that patch ... can't see any performance
improvements.  but... works fine. and mem* generally better than str*
one, right?
