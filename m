Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764Ab0HJOaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 10:30:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61159 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860Ab0HJOaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 10:30:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf build broke by list_head changes...
Date: Tue, 10 Aug 2010 16:29:53 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>, Chris Metcalf <cmetcalf@tilera.com>,
        David Miller <davem@davemloft.net>, willy@linux.intel.com,
        linux-kernel@vger.kernel.org
References: <20100809.235746.115919762.davem@davemloft.net> <20100810124445.GA14843@merkur.ravnborg.org> <20100810134600.GF18824@ghostprotocols.net>
In-Reply-To: <20100810134600.GF18824@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008101629.53768.arnd@arndb.de>
X-Provags-ID: V02:K0:azwL5Pfld5GCOqDuNWYGji7/ttn7BHLw3DIbb5sVd3G
 +EUXsmlnUW5M2ENCCf6fUt3AMfC/8pMg3BX0KF5UH1haDYMD4k
 FYDtIxTiP5wVd/Qygbeg5lulo8SiXiTbPCWt9kndZwURdNAhBG
 f9dVvYuk5HQvVYSYl94H8X05nK5TkmitUKxaVb51tpELVV4ws6
 4oiqnUA4MFOgVAf+bcwTA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 August 2010, Arnaldo Carvalho de Melo wrote:
> It started just keeping private copies, I guess it should get back to
> that since the reaction to this kind of same source repo code sharing
> was, well, not good :-)
> 
> Alternatives?

If perf wants to play tricks with the header files, we should probably
make them explicit, as in this ugly bit of code.

	Arnd

diff --git a/include/linux/types.h b/include/linux/types.h
index 01a082f..0e0998a 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -178,7 +178,7 @@ typedef __u64 __bitwise __be64;
 typedef __u16 __bitwise __sum16;
 typedef __u32 __bitwise __wsum;
 
-#ifdef __KERNEL__
+#if defined(__KERNEL__) || defined(__PERF__)
 typedef unsigned __bitwise__ gfp_t;
 typedef unsigned __bitwise__ fmode_t;
 
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 26f626d..9806dc9 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -225,7 +225,7 @@ ifndef PERF_DEBUG
   CFLAGS_OPTIMIZE = -O6
 endif
 
-CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
+CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D__PERF__ -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
 EXTLIBS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
 ALL_LDFLAGS = $(LDFLAGS)
