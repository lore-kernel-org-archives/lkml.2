Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab0K3Oo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 09:44:27 -0500
Received: from zfrontend2.aha.ru ([195.2.83.148]:64972 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751473Ab0K3Oo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 09:44:26 -0500
From: "werner" <w.landgraf@ru.ru>
Subject: Re: [PATCH] staging: easycap needs  smp_lock.h, fixes build
 error
To: randy.dunlap@oracle.com, greg@kroah.com, linux-kernel@vger.kernel.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Tue, 30 Nov 2010 10:44:21 -0400
Message-ID: <web-413291852@zbackend1.aha.ru>
In-Reply-To: <20101122121237.38cdd369.randy.dunlap@oracle.com>
References: <web-407197955@zbackend1.aha.ru>
 	<20101122043520.GA10958@kroah.com>
 	<20101121205626.4589e544.randy.dunlap@oracle.com>
 	<20101121211311.05963007.randy.dunlap@oracle.com>
 	<20101122194736.GA29830@kroah.com>
 <20101122121237.38cdd369.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HELLO

I dont believe this ... my 2.6.37-rc4 compilation gone bad 
again, because of the same error, and I have to recompile 
/ re-package it, what needs some hours again ..  :(  :(

  The correction below worked on 2.6.37-rc3 (i.e. insert 
#include <linux/smp_lock.h>  into easycap_main.h)


WHY THIS WASN'T PATCHED SINCE LONG TIME ?   Is the 
situation of the kernel developers similar bad like of the 
open office developers, so that they should be exchanged 
???


w.landgraf

===========================================================
On Mon, 22 Nov 2010 12:12:37 -0800
  Randy Dunlap <randy.dunlap@oracle.com> wrote:
>From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Add header file to fix build error:
> 
> drivers/staging/easycap/easycap_main.c:4251: error: 
>implicit declaration of function 'lock_kernel'
> drivers/staging/easycap/easycap_main.c:4254: error: 
>implicit declaration of function 'unlock_kernel'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
> drivers/staging/easycap/easycap.h |    1 +
> 1 file changed, 1 insertion(+)
> 
> --- lnx-2637-rc3.orig/drivers/staging/easycap/easycap.h
> +++ lnx-2637-rc3/drivers/staging/easycap/easycap.h
> @@ -75,6 +75,7 @@
> #include <linux/errno.h>
> #include <linux/init.h>
> #include <linux/slab.h>
> +#include <linux/smp_lock.h>
> #include <linux/module.h>
> #include <linux/kref.h>
> #include <linux/usb.h>
> 
> 

"werner" <w.landgraf@ru.ru>
---
Professional hosting for everyone - http://www.host.ru
