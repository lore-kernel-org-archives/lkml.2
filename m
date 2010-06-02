Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932827Ab0FBQv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 12:51:26 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:44039 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932812Ab0FBQvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 12:51:24 -0400
Message-ID: <4C068BAA.4030004@oracle.com>
Date: Wed, 02 Jun 2010 09:49:46 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Nobin Mathew <nobin.mathew@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-kbuild@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
Subject: [TEMP PATCH] Re: make ARM=arm menuconfig problem in mainline
References: <AANLkTikC61Y9g-WbqwgGDghDSy2XtgraFSRoZYkHRGTG@mail.gmail.com>	<AANLkTilEYHVHJrj_KgF48OYCSEUcsKLi57Q_Y73d9va-@mail.gmail.com>	<20100602085748.6771e025.randy.dunlap@oracle.com> <AANLkTilpzeYVExQfLgpVmS3bPvb_h3kmWaatidekI-0r@mail.gmail.com>
In-Reply-To: <AANLkTilpzeYVExQfLgpVmS3bPvb_h3kmWaatidekI-0r@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090204.4C068BED.017A:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/10 09:08, Nobin Mathew wrote:
> 
> On Wed, Jun 2, 2010 at 9:27 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> On Wed, 2 Jun 2010 20:04:28 +0530 Nobin Mathew wrote:
>>
>>> adding linux-arm-kernel@lists.infradead.org
>>>
>>> Hi,
>>>
>>> The following entry creates problem in ARM System type menu. I am
>>> using a Fedora 12 system.
>>
>> What kind of problem does it create?
>> It seems to work for me (on f11, not f12).
>> Does it have something to do with F12 specifically?
>>
>>
>>> Length of bool "Samsung S3C2410, S3C2412, S3C2413, S3C2416, S3C2440,
>>> S3C2442, S3C2443, S3C2450" is the problem. How can I fix it.
>>
>> Describe the problem, please.

[please don't top-post]

> Sorry if attachments are not allowed, when I go to select ARM system
> type(OMAP, Davinci etc), I am not seeing any entries there in the pop
> up window. When I remove  bool "Samsung S3C2410, S3C2412, S3C2413,
> S3C2416, S3C2440,
>>> S3C2442, S3C2443, S3C2450"  it is working fine. I feel it is something to do with length of that string.
> 
> Thanks
> Nobin


OK, I see that now.  Well, it is some kind of problem.
Adding cc to linux-kbuild mailing list.


The patch below fixes the problem temporarily, but the bool string length does
seem to be a problem.

Thanks for your report.

-- 
From: Randy Dunlap <randy.dunlap@oracle.com>

The bool "long string" causes the choices not to be displayed,
so temporarily change it to a shorter string until a real fix
is found.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Reported-by: Nobin Mathew <nobin.mathew@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>
---
 arch/arm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20100602.orig/arch/arm/Kconfig
+++ linux-next-20100602/arch/arm/Kconfig
@@ -629,7 +629,7 @@ config ARCH_SA1100
 	  Support for StrongARM 11x0 based boards.
 
 config ARCH_S3C2410
-	bool "Samsung S3C2410, S3C2412, S3C2413, S3C2416, S3C2440, S3C2442, S3C2443, S3C2450"
+	bool "Samsung S3C24xx"
 	select GENERIC_GPIO
 	select ARCH_HAS_CPUFREQ
 	select HAVE_CLK
