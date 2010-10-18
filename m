Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab0JRInV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 04:43:21 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:50993 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753187Ab0JRInU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 04:43:20 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/gYgI1iHDgto64JXTtyI/VVTuxlXbzGkbZFRIA7q
	+DuTGaEvdCSkBD
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: Fwd: Re: UML kernel crash of v2.6.36-rcX kernel
Date: Mon, 18 Oct 2010 10:43:12 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35.6; KDE/4.4.5; i686; ; )
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>, Al Viro <viro@zeniv.linux.org.uk>
References: <201010131328.06465.toralf.foerster@gmx.de> <201010171555.40453.toralf.foerster@gmx.de> <20101017201837.GA16458@lst.de>
In-Reply-To: <20101017201837.GA16458@lst.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010181043.14253.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Christoph Hellwig wrote at 22:18:37
> I really can't see any relation to the patch.  Can you try the some
> things in the following order, please:
...
>  (4) re-apply the include/linux/statfs.h changes and see if it still
>       boots

The first half of step 4 was it (I did not apply the "Definitions for the flag 
in f_flag.") :

diff --git a/include/linux/statfs.h b/include/linux/statfs.h
index b34cc82..0166d32 100644
--- a/include/linux/statfs.h
+++ b/include/linux/statfs.h
@@ -2,7 +2,6 @@
 #define _LINUX_STATFS_H
 
 #include <linux/types.h>
-
 #include <asm/statfs.h>
 
 struct kstatfs {
@@ -16,7 +15,29 @@ struct kstatfs {
        __kernel_fsid_t f_fsid;
        long f_namelen;
        long f_frsize;
-   long f_spare[5];
+ long f_flags;
+ long f_spare[4];
 };



FWIW the uml kernel boots fine even with that commit however it crashed after 
a special http request : $> wget http://n22_uml/phpsysinfo/

-- 
MfG/Kind regards
Toralf Förster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

