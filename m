Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881Ab1JRIoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 04:44:55 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51290 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756836Ab1JRIox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 04:44:53 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1318922541.1789.36.camel@epip-laptop>
References: <1317824987.2674.1.camel@phoenix> <1318922541.1789.36.camel@epip-laptop>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 18 Oct 2011 16:44:32 +0800
Message-ID: <CAF+7xW=nhutZ7GcSr8j6bT5GZFoKmkmbdRCw+enRKRfPb_bThQ@mail.gmail.com>
Subject: Re: [PATCH] rtc: rtc-puv3: Add __devinit and __devexit markers for
 probe and remove
To: gxt@mprc.pku.edu.cn
Cc: Michal Marek <mmarek@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Guan,

> For puv3_rtc_probe, I think it should be in the white-list, but warnings
> are yielded.
> For puv3_rtc_remove, the warning could be disappeared by modifying
> __devexit to __exit, however is it proper?
>

I'm not able to reproduce it on linux-next tree (20111014).
If I Enable loadable module support, I got below build error:

  CC      arch/unicore32/kernel/ksyms.o
arch/unicore32/kernel/ksyms.c:39: error: 'csum_partial_copy_nocheck'
undeclared here (not in a function)
arch/unicore32/kernel/ksyms.c:39: warning: type defaults to 'int' in
declaration of 'csum_partial_copy_nocheck'
arch/unicore32/kernel/ksyms.c:40: error: '__csum_ipv6_magic'
undeclared here (not in a function)
arch/unicore32/kernel/ksyms.c:40: warning: type defaults to 'int' in
declaration of '__csum_ipv6_magic'
arch/unicore32/kernel/ksyms.c:44: error: '__raw_readsb' undeclared
here (not in a function)
arch/unicore32/kernel/ksyms.c:44: warning: type defaults to 'int' in
declaration of '__raw_readsb'
arch/unicore32/kernel/ksyms.c:47: error: '__raw_readsw' undeclared
here (not in a function)
arch/unicore32/kernel/ksyms.c:47: warning: type defaults to 'int' in
declaration of '__raw_readsw'
arch/unicore32/kernel/ksyms.c:50: error: '__raw_readsl' undeclared
here (not in a function)
arch/unicore32/kernel/ksyms.c:50: warning: type defaults to 'int' in
declaration of '__raw_readsl'
arch/unicore32/kernel/ksyms.c:53: error: '__raw_writesb' undeclared
here (not in a function)
arch/unicore32/kernel/ksyms.c:53: warning: type defaults to 'int' in
declaration of '__raw_writesb'
arch/unicore32/kernel/ksyms.c:56: error: '__raw_writesw' undeclared
here (not in a function)
arch/unicore32/kernel/ksyms.c:56: warning: type defaults to 'int' in
declaration of '__raw_writesw'
arch/unicore32/kernel/ksyms.c:59: error: '__raw_writesl' undeclared
here (not in a function)
arch/unicore32/kernel/ksyms.c:59: warning: type defaults to 'int' in
declaration of '__raw_writesl'
arch/unicore32/kernel/ksyms.c:80: error: '__get_user_1' undeclared
here (not in a function)
arch/unicore32/kernel/ksyms.c:80: warning: type defaults to 'int' in
declaration of '__get_user_1'
arch/unicore32/kernel/ksyms.c:81: error: '__get_user_2' undeclared
here (not in a function)
arch/unicore32/kernel/ksyms.c:81: warning: type defaults to 'int' in
declaration of '__get_user_2'
arch/unicore32/kernel/ksyms.c:82: error: '__get_user_4' undeclared
here (not in a function)
arch/unicore32/kernel/ksyms.c:82: warning: type defaults to 'int' in
declaration of '__get_user_4'
arch/unicore32/kernel/ksyms.c:84: error: '__put_user_1' undeclared
here (not in a function)
arch/unicore32/kernel/ksyms.c:84: warning: type defaults to 'int' in
declaration of '__put_user_1'
arch/unicore32/kernel/ksyms.c:85: error: '__put_user_2' undeclared
here (not in a function)
arch/unicore32/kernel/ksyms.c:85: warning: type defaults to 'int' in
declaration of '__put_user_2'
arch/unicore32/kernel/ksyms.c:86: error: '__put_user_4' undeclared
here (not in a function)
arch/unicore32/kernel/ksyms.c:86: warning: type defaults to 'int' in
declaration of '__put_user_4'
arch/unicore32/kernel/ksyms.c:87: error: '__put_user_8' undeclared
here (not in a function)
arch/unicore32/kernel/ksyms.c:87: warning: type defaults to 'int' in
declaration of '__put_user_8'
make[1]: *** [arch/unicore32/kernel/ksyms.o] Error 1
make: *** [arch/unicore32/kernel] Error 2

I also try to clone unicore tree, but I got connection timed out. :-(

axel@phoenix:~/repos/git$ git clone
git://master.kernel.org/pub/scm/linux/kernel/git/epip/linux-unicore.git
Cloning into linux-unicore...
master.kernel.org[0: 140.211.167.34]: errno=Connection timed out
fatal: unable to connect a socket (Connection timed out)

Regards,
Axel
