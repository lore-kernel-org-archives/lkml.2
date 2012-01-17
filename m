Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab2AQWJN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 17:09:13 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44877 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820Ab2AQWJL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 17:09:11 -0500
MIME-Version: 1.0
In-Reply-To: <20120117212639.GA17297@kroah.com>
References: <1326834845.3020.36.camel@dabdike>
	<20120117212639.GA17297@kroah.com>
Date: Tue, 17 Jan 2012 17:09:10 -0500
X-Google-Sender-Auth: ZNWACQtya1-pD23CpuFXi3e-yKU
Message-ID: <CAP=VYLpsdy5ws6PA-DREx-Z6MQP-7djcB3d31kRhR+KT-a74CQ@mail.gmail.com>
Subject: Re: Fix compile breakage with kref.h
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: James Bottomley <jbottomley@parallels.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 4:26 PM, Greg Kroah-Hartman <greg@kroah.com> wrote:
> On Tue, Jan 17, 2012 at 09:14:05PM +0000, James Bottomley wrote:
>> This set of build failures just started appearing on parisc:
>>
>> In file included from drivers/input/serio/serio_raw.c:12:
>> include/linux/kref.h: In function 'kref_get':
>> include/linux/kref.h:40: error: 'TAINT_WARN' undeclared (first use in this function)
>> include/linux/kref.h:40: error: (Each undeclared identifier is reported only once
>> include/linux/kref.h:40: error: for each function it appears in.)
>> include/linux/kref.h: In function 'kref_sub':
>> include/linux/kref.h:65: error: 'TAINT_WARN' undeclared (first use in this function)
>>
>> It happens because TAINT_WARN is defined in kernel.h and this particular
>> compile doesn't seem to include it (no idea why it's just
>> manifesting ... probably some #include file untangling exposed it).  Fix
>> by adding #include <linux/kernel.h> to linux/kref.h
>
> Does adding <linux/bug.h> fix it instead?  We are using WARN_ON() here.
> Hm, but that needs kernel.h as well, ugh, what a mess.

I've got some work done already towards cleaning this up; aiming for
getting it done and in linux-next for the 3.4 cycle.

https://lkml.org/lkml/2012/1/4/455

Paul.
---

>
>> Signed-off-by: James Bottomley <JBottomley@Parallels.com>
>
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
