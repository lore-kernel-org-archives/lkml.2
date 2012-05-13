Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab2EMVkZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 17:40:25 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62945 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab2EMVkY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 17:40:24 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 13 May 2012 14:40:03 -0700
X-Google-Sender-Auth: 5Oy7y_uO2qPPwysAuuCWoqdtGps
Message-ID: <CA+55aFwB-3rsrVo1vur6drZMvhSWNHAJZfEYC=WXfpwwvLfxFQ@mail.gmail.com>
Subject: stale object files (was Re: Linux-3.4-rc7)
To: =?ISO-8859-2?Q?Pawe=B3_Sikora?= <pluto@pld-linux.org>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, added the appropriate kbuild people: Machal - skb_dev_set() no
longer exists, there are no users of it, so it looks like something
doesn't get rebuilt correctly.

Paweł, can you please also send us the config file you're using, then
we can recreate the exact setup you have.

                     Linus

On Sun, May 13, 2012 at 2:13 PM, Paweł Sikora <pluto@pld-linux.org> wrote:
>
> starting from current rc7 build tree...
>
> $ cp .config ../config
> $ make distclean
> $ git co v3.4-rc5
> $ cp ../config .config
> $ make oldconfig
> $ make -j8
> $ git co v3.4-rc7
> $ make oldconfig
> $ make -j8
> $ su
> $ make modules_install INSTALL_FW_PATH=/lib/firmware/3.4.0-rc7
> (...)
>  DEPMOD  3.4.0-rc7
> WARNING: /lib/modules/3.4.0-rc7/kernel/drivers/net/macvlan.ko needs unknown symbol skb_set_dev
> WARNING: /lib/modules/3.4.0-rc7/kernel/net/8021q/8021q.ko needs unknown symbol skb_set_dev
> (...)
>
> installed software:
>
> make-3.82-3.x86_64
> gcc-4.6.3-4.x86_64
> binutils-2.22.52.0.3-1.x86_64
