Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab1CPPRI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 11:17:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62868 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab1CPPRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 11:17:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bCbdqDZRpWfrYMTm0z5nhH186/Z9tX/Y/cjX53IdUePoafDtUe8NguvNjXIj97Q2ir
         o09Y+Cu9fSEXX6r/KNxskkcBGUxo3BhFeq4YMrTk/HVYmRNDNnYTAH+zXxfb3m1OWxXK
         /Y9YCptk8QzsD4CJXDnBRufVro8AoksBjg/xE=
Subject: Re: 2.6.38 Compile Failure e1000e Module
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Frank Peters <frank.peters@comcast.net>
Cc: linux-kernel@vger.kernel.org, Bruce Allan <bruce.w.allan@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>
In-Reply-To: <20110316103318.19bd03e4.frank.peters@comcast.net>
References: <20110316103318.19bd03e4.frank.peters@comcast.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Mar 2011 16:16:57 +0100
Message-ID: <1300288617.3202.10.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 16 mars 2011 à 10:33 -0400, Frank Peters a écrit :
> Hello,
> 
> I cannot compile kernel 2.6.38.  Apparently, there is a build failure
> with the e1000e module (ethernet driver).  The brief error message is this:
> 
> ERROR: "crc32_le" [drivers/net/e1000e/e1000e.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 
> My compiler is gcc-4.5.2 on a Gentoo x64 system.  The kernel source
> is the stock source from kernel.org.
> 
> Please CC to frank.peters (at) comcast.net.

Hi Franck

Probably coming from commit fe46f58fa61f02
(e1000e: use either_crc_le() rather than re-write it)

Could you try following patch ?

Thanks

[PATCH] e1000e: fix kconfig for crc32 dependency

ERROR: "crc32_le" [drivers/net/e1000e/e1000e.ko] undefined!

Reported-by: Frank Peters <frank.peters@comcast.net>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Bruce Allan <bruce.w.allan@intel.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 0382332..90d1d3c 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -2098,6 +2098,7 @@ config E1000
 
 config E1000E
 	tristate "Intel(R) PRO/1000 PCI-Express Gigabit Ethernet support"
+	select CRC32
 	depends on PCI && (!SPARC32 || BROKEN)
 	---help---
 	  This driver supports the PCI-Express Intel(R) PRO/1000 gigabit


