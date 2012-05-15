Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965694Ab2EOCa4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:30:56 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56205 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965117Ab2EOCax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:30:53 -0400
X-AuditID: 9c930179-b7bb9ae000000ea5-e0-4fb1bfda3a54
Message-ID: <4FB1BFFC.8080405@kernel.org>
Date: Tue, 15 May 2012 11:31:24 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] zram: remove comment in Kconfig
References: <1336985134-31967-1-git-send-email-minchan@kernel.org> <1336985134-31967-2-git-send-email-minchan@kernel.org> <4FB119CA.2080606@linux.vnet.ibm.com>
In-Reply-To: <4FB119CA.2080606@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2012 11:42 PM, Seth Jennings wrote:

> On 05/14/2012 03:45 AM, Minchan Kim wrote:
> 
>> Exactly speaking, zram should has dependency with
>> zsmalloc, not x86. So x86 dependeny check is redundant.
>>
>> Signed-off-by: Minchan Kim <minchan@kernel.org>
>> ---
>>  drivers/staging/zram/Kconfig |    4 +---
>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/drivers/staging/zram/Kconfig b/drivers/staging/zram/Kconfig
>> index 9d11a4c..ee23a86 100644
>> --- a/drivers/staging/zram/Kconfig
>> +++ b/drivers/staging/zram/Kconfig
>> @@ -1,8 +1,6 @@
>>  config ZRAM
>>  	tristate "Compressed RAM block device support"
>> -	# X86 dependency is because zsmalloc uses non-portable pte/tlb
>> -	# functions
>> -	depends on BLOCK && SYSFS && X86
>> +	depends on BLOCK && SYSFS
> 
> 
> Two comments here:
> 
> 1) zram should really depend on ZSMALLOC instead of selecting it
> because, as the patch has it, zram could be selected on an arch that
> zsmalloc doesn't support.


Argh, Totally my mistake. my patch didn't match with my comment, either. :(

> 
> 2) This change would need to be done in zcache as well.


I see.
Seth, Thanks.

send v2.

== CUT_HERE ==

>From be81aec5a4f35139aae2bf3d18139fbc114897ca Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Tue, 15 May 2012 11:26:48 +0900
Subject: [PATCH] [zram,zcache] remove dependency with x86 

Exactly saying, [zram|zcache] should has a dependency with
zsmalloc, not x86. So replace x86 dependeny with ZSMALLOC.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/staging/zcache/Kconfig |    3 +-- 
 drivers/staging/zram/Kconfig   |    3 +-- 
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/zcache/Kconfig b/drivers/staging/zcache/Kconfig
index 7048e01..ceb7f28 100644
--- a/drivers/staging/zcache/Kconfig
+++ b/drivers/staging/zcache/Kconfig
@@ -2,8 +2,7 @@ config ZCACHE
        bool "Dynamic compression of swap pages and clean pagecache pages"
        # X86 dependency is because zsmalloc uses non-portable pte/tlb
        # functions
-       depends on (CLEANCACHE || FRONTSWAP) && CRYPTO=y && X86
-       select ZSMALLOC
+       depends on (CLEANCACHE || FRONTSWAP) && CRYPTO=y && ZSMALLOC
        select CRYPTO_LZO
        default n
        help
diff --git a/drivers/staging/zram/Kconfig b/drivers/staging/zram/Kconfig
index 9d11a4c..e3ac62d 100644
--- a/drivers/staging/zram/Kconfig
+++ b/drivers/staging/zram/Kconfig
@@ -2,8 +2,7 @@ config ZRAM
        tristate "Compressed RAM block device support"
        # X86 dependency is because zsmalloc uses non-portable pte/tlb
        # functions
-       depends on BLOCK && SYSFS && X86
-       select ZSMALLOC
+       depends on BLOCK && SYSFS && ZSMALLOC
        select LZO_COMPRESS
        select LZO_DECOMPRESS
        default n
-- 
1.7.9.5



-- 
Kind regards,
Minchan Kim
