Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab1ELLQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 07:16:34 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37264 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab1ELLQd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 07:16:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=c63izd6VqfCf4tOMj+XSgaUQ01b+AeVEdniERL0rMnFAqjUa5np+wCRWOJZRc9ucFB
         TmmCIt3F2aXhUFRNTdY0q0rbeBJdB0vgrx7R+Dvn8zCBm81OgJQqe8WBIWDaMw8Apk0R
         t+0Y5v6JckBnNo27yE0+Nb1GRhpHI/RfYuQyI=
MIME-Version: 1.0
In-Reply-To: <009c01cc108b$4635c7d0$d2a15770$@com>
References: <BANLkTikefReiFUggT8iPv0mOmY=+OOOS-A@mail.gmail.com>
	<BANLkTim-FmuENeU_Cai+nYnTP+uJTEn3PA@mail.gmail.com>
	<BANLkTi=S3VR1mxc0bsL4+N3ksHeo3scg3A@mail.gmail.com>
	<009c01cc108b$4635c7d0$d2a15770$@com>
Date: Thu, 12 May 2011 14:16:32 +0300
Message-ID: <BANLkTi=wg=RgyEWzL9_fwUymhFDaccQCfw@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IOetlOWkjTogcHJvYmxlbSB3aXRoIGttZW1sZWFr?=
From: Daniel Baluta <daniel.baluta@gmail.com>
To: chenxi <chenxi05@baidu.com>
Cc: Maxin B John <maxin.john@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 12:59 PM, chenxi <chenxi05@baidu.com> wrote:
> Thx, Maxin :)
> ok
> I did steps below:
> 1 make oldconfig
> 2 vim .config
>  ...
>  CONFIG_DEBUG_FS = y
>  CONFIG_DEBUG_KMEMLEAK = y
>  CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE = 1200
>  ...
> 3 make ; make modules ; and replace the kernel; reboot
> 4 mount -t debugfs debugfs /sys/kernel/debug
> 4 I wrote a module like this
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/kernel.h>
>  #include <linux/vmalloc.h>
>
> void myfunc(void)
> {
>        char *ptr;
>        ptr = vmalloc(512);
>        ptr = vmalloc(512);
>        ptr = vmalloc(512);
> }
>
> int hello_init(void)
> {
>        printk(KERN_ALERT "Hello World");
>        myfunc();
>        return 0;
> }
>
> static void hello_exit(void)
> {
>        printk(KERN_ALERT "Goodbye World");
> }
>
> module_init(hello_init);
> module_exit(hello_exit);
>
> MODULE_LICENSE("GPL v2");
>
> 5 clear the kmemleak
>  Echo clear > /sys/kernel/debug/kmemleak
> 6 insmod the module
>  Insmod xxx.ko

Can you please remove your module?
I think the memory is leaked at unload time.

thanks,
Daniel
