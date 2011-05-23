Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab1EWOKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 10:10:22 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37243 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091Ab1EWOKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 10:10:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=N8mOoLDR9QPFZ0s9XRL5PYb8RfIAvqmpWSTixNohN3RskQtGkXxDD6iET70cePO0IO
         8lieSTLApg7uV6k227elLc0mPDzRPvKxJlpCDuycXKmz0Jpg2YUfNKC6dv/e2WTqFIhX
         Vu4C0slUGl/y2eM9In0JNTvEGmWxSfbgxAsmo=
MIME-Version: 1.0
In-Reply-To: <201105231527.53805.stevie.trujillo@gmail.com>
References: <201105231527.53805.stevie.trujillo@gmail.com>
Date: Mon, 23 May 2011 22:10:17 +0800
Message-ID: <BANLkTi=iGzkSwWPZrFPBJZYg6x=dDBb5Eg@mail.gmail.com>
Subject: Re: ramoops: is using platform_drivers correct?
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Stevie Trujillo <stevie.trujillo@gmail.com>
Cc: marco.stornelli@gmail.com, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 9:27 PM, Stevie Trujillo
<stevie.trujillo@gmail.com> wrote:
> Hello,
>
> ramoops (drivers/char/ramoops.c) is for "all" computers right? When I try to
> load it on my laptop, I get ENODEV. This is caused by platform_driver_probe()
> - the code never reaches the ramoops probe callback.
>
> After I removed the platform_driver stuff, moving everything into ramoops_init
> and ramoops_exit it worked.

Actually that was changed by Kyungmin, Cc'ing...

commit c3b92ce9e75f6353104fc7f8e32fb9fdb2550ad0
Author: Kyungmin Park <kyungmin.park@samsung.com>
Date:   Wed Oct 27 15:34:52 2010 -0700

    ramoops: use the platform data structure instead of module params

    As each board and system has different memory for ramoops.  It's better to
    define the platform data instead of module params.

    [akpm@linux-foundation.org: fix ramoops_remove() return type]
    Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
    Cc: Marco Stornelli <marco.stornelli@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
