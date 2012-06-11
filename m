Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab2FKQXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 12:23:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384Ab2FKQXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 12:23:13 -0400
Message-ID: <4FD61B6D.7040405@redhat.com>
Date: Mon, 11 Jun 2012 13:23:09 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: edac-devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] edac: rewrite the sysfs code to use struct device
References: <20120608125219.GA31359@aftab.osrc.amd.com>
In-Reply-To: <20120608125219.GA31359@aftab.osrc.amd.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 08-06-2012 09:52, Borislav Petkov escreveu:
>  From c0d119126e1b6daf9fe71614971233ffc90a873a Mon Sep 17 00:00:00 2001
> From: Mauro Carvalho Chehab <mchehab@redhat.com>
> Date: Mon, 16 Apr 2012 16:41:11 -0300
> Subject: [PATCH] edac: rewrite the sysfs code to use struct device
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 

<skip/>

[will check the UTF-8 issue later]

> 
> Hrrm,
> 
> this patch doesn't build here, ontop of 3.5-rc1, config attached.
> 
> In file included from arch/x86/kernel/nmi.c:23:0:
> include/linux/edac.h:452:16: error: field ‘dev’ has incomplete type
> include/linux/edac.h:488:16: error: field ‘dev’ has incomplete type
> include/linux/edac.h:498:16: error: field ‘dev’ has incomplete type
> include/linux/edac.h:553:18: error: field ‘dev’ has incomplete type
> include/linux/edac.h:554:20: error: field ‘bus’ has incomplete type
> make[2]: *** [arch/x86/kernel/nmi.o] Error 1
> make[1]: *** [arch/x86/kernel] Error 2
> make[1]: *** Waiting for unfinished jobs....
> In file included from drivers/edac/edac_stub.c:16:0:
> include/linux/edac.h:452:16: error: field ‘dev’ has incomplete type
> include/linux/edac.h:488:16: error: field ‘dev’ has incomplete type
> include/linux/edac.h:498:16: error: field ‘dev’ has incomplete type
> include/linux/edac.h:553:18: error: field ‘dev’ has incomplete type
> include/linux/edac.h:554:20: error: field ‘bus’ has incomplete type
> make[2]: *** [drivers/edac/edac_stub.o] Error 1
> make[1]: *** [drivers/edac] Error 2
> make[1]: *** Waiting for unfinished jobs....
> make: *** [arch/x86] Error 2
> make: *** Waiting for unfinished jobs....
> 

I'll fold the enclosed patch. It should fix this issue.

diff --git a/include/linux/edac.h b/include/linux/edac.h
index aeaafd0..a2b0b6f 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -13,6 +13,7 @@
 #define _LINUX_EDAC_H_
 
 #include <linux/atomic.h>
+#include <linux/device.h>
 #include <linux/kobject.h>
 #include <linux/completion.h>
 #include <linux/workqueue.h>
