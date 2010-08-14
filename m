Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025Ab0HNV4B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 17:56:01 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:34131 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756931Ab0HNVz7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 17:55:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=KOyfFd9AoB4XJ9bduHl4f2TMVXgSsVqRi1a0SfEHtqjodwF04SXq7UdLNe+rFE5FJt
         559dipos9n71shKgYfVROe2nECkEd3uaSkvvlJXDTWkqeUqTYdTOqKBjY0cmUjkoArKi
         PWuTnN1dT9mQmqAO/5D89Dy8j3DL8wTECnHs8=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1008102119170.20140@ayla.of.borg>
References: <alpine.DEB.2.00.1008102119170.20140@ayla.of.borg>
Date: Sat, 14 Aug 2010 23:55:58 +0200
X-Google-Sender-Auth: 7Ft4KYRICjUGM7Di66uuGRxYM34
Message-ID: <AANLkTimyeZbxU68TB0N-+Fcug1Ec035OvOtbAYPbhQH2@mail.gmail.com>
Subject: Re: [PATCH] staging: spectra needs <linux/slab.h>
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Randy Dunlap <randy.dunlap@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/10 Geert Uytterhoeven <geert@linux-m68k.org>:
> On one of my m68k test builds I get:
>
> drivers/staging/spectra/ffsport.c: In function ‘ioctl_read_page_data’:
> drivers/staging/spectra/ffsport.c:196: error: implicit declaration of function ‘kmalloc’
> drivers/staging/spectra/ffsport.c:196: warning: assignment makes pointer from integer without a cast
> drivers/staging/spectra/ffsport.c:212: error: implicit declaration of function ‘kfree’
> drivers/staging/spectra/ffsport.c: In function ‘ioctl_write_page_data’:
> drivers/staging/spectra/ffsport.c:229: warning: assignment makes pointer from integer without a cast
> drivers/staging/spectra/ffsport.c: In function ‘SBD_setup_device’:
> drivers/staging/spectra/ffsport.c:633: warning: assignment makes pointer from integer without a cast

Still more errors:

        drivers/staging/spectra/ffsport.c: error: too many arguments to function
 ‘blk_queue_ordered’:  => 655
        drivers/staging/spectra/ffsport.c: error: unknown field ‘locked_ioctl’ s
pecified in initializer:  => 605
        drivers/staging/spectra/ffsport.c: error: ‘REQ_LB_OP_FLUSH’ undeclared (
first use in this function):  => 280, 301
        drivers/staging/spectra/ffsport.c: error: ‘REQ_TYPE_LINUX_BLOCK’ undecla
red (first use in this function):  => 278, 300

Some of these have been reported by Randy in linux-next on ... July 8.
The locked_ioctl one is a `new' one, though...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
