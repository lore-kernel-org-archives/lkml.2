Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427Ab2FUDcM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 23:32:12 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:41442 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758322Ab2FUDcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 23:32:10 -0400
MIME-Version: 1.0
In-Reply-To: <20120621114546.1e5df51bd231ee481d63705c@canb.auug.org.au>
References: <20120620173536.b856bbd97497cf02ddf8d6d2@canb.auug.org.au>
	<4FE27471.8050505@xenotime.net>
	<20120621114546.1e5df51bd231ee481d63705c@canb.auug.org.au>
Date: Thu, 21 Jun 2012 12:32:09 +0900
Message-ID: <CAKYAXd_2uj+f=WN5fqqmGwsjW59wy_pV7xwPA8xLmH5d1aVf+A@mail.gmail.com>
Subject: Re: linux-next: Tree for Jun 20 (hweight return type)
From: Namjae Jeon <linkinjeon@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/21, Stephen Rothwell <sfr@canb.auug.org.au>:
> On Wed, 20 Jun 2012 18:10:09 -0700 Randy Dunlap <rdunlap@xenotime.net>
> wrote:
>>
>> Someone changes the return type of __const_hweight8() to
>> (unsigned long).  That causes printk format warnings when
>> hweight8/16() etc. is passed a constant:
>
> That would be "include/linux/bitops.h: fix warning" from the akpm tree
> (adding cc's).
This patch is made for fix warning message. but it looks affect other side.
Sorry for noise, I will look for other mehod. Once would you plz
revert this patch in linux-next and akpm tree ?
Thanks.
>
>>
>> drivers/input/joystick/analog.c:412:4: warning: format '%d' expects type
>> 'int', but argument 4 has type 'long unsigned int'
>> drivers/input/joystick/analog.c:412:4: warning: format '%d' expects type
>> 'int', but argument 5 has type 'long unsigned int'
>> drivers/input/joystick/analog.c:416:5: warning: format '%d' expects type
>> 'int', but argument 5 has type 'long unsigned int'
>>
>>
>> Note that in
>>
>> #define hweight8(w)  (__builtin_constant_p(w) ? __const_hweight8(w)  :
>> __arch_hweight8(w))
>>
>> __arch_hweight*() still returns unsigned int while __const_hweight*()
>> returns unsigned long.  This can't be good, can it?
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
