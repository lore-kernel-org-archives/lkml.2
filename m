Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab1DRV4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 17:56:47 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:36213 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab1DRV4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 17:56:44 -0400
Message-ID: <4DACB38D.2070102@oracle.com>
Date: Mon, 18 Apr 2011 14:56:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: werner <w.landgraf@ru.ru>
CC: tj@kernel.org, gregkh@suse.de, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: 2.6.39-rc3-gitX  compiling errors of olpc-dcon_xo_1 and i82975x-edac
References: <web-507861711@zbackend1.aha.ru>
In-Reply-To: <web-507861711@zbackend1.aha.ru>
Content-Type: multipart/mixed;
 boundary="------------080105030904020706040108"
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4DACB390.00FE:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080105030904020706040108
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 04/18/11 14:49, werner wrote:
> =============================
> 
>   CC [M]  drivers/staging/olpc_dcon/olpc_dcon_xo_1.o
> drivers/staging/olpc_dcon/olpc_dcon_xo_1.c: In function 'dcon_wiggle_xo_1':
> drivers/staging/olpc_dcon/olpc_dcon_xo_1.c:168: error: implicit
> declaration of function 'udelay'
> 

Andrew has merged a patch for this one into his MM tree.
I'm attaching it below.

> 
>   CC [M]  drivers/edac/i82975x_edac.o
> drivers/edac/i82975x_edac.c: In function 'i82975x_process_error_info':
> drivers/edac/i82975x_edac.c:298: warning: integer constant is too large
> for 'unsigned long' type

warning, not error.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

--------------080105030904020706040108
Content-Type: text/x-patch;
 name="stag-olpcdcon-delayh.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="stag-olpcdcon-delayh.patch"

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build error, needs delay.h:

drivers/staging/olpc_dcon/olpc_dcon_xo_1.c:168: error: implicit declaration of function 'udelay'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andres Salomon <dilinger@queued.net>
---
 drivers/staging/olpc_dcon/olpc_dcon_xo_1.c |    1 +
 1 file changed, 1 insertion(+)

Can we get something in MAINTAINERS for OLPC, please?

--- mmotm-2011-0331-1448.orig/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
+++ mmotm-2011-0331-1448/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
@@ -11,6 +11,7 @@
  * License as published by the Free Software Foundation.
  */
 #include <linux/cs5535.h>
+#include <linux/delay.h>
 #include <linux/gpio.h>
 #include <asm/olpc.h>
 

--------------080105030904020706040108--
