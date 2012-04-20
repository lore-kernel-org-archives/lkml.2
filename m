Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab2DTTIG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 15:08:06 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:39075 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565Ab2DTTIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 15:08:04 -0400
Message-ID: <4F91B3C1.5080507@linux.vnet.ibm.com>
Date: Fri, 20 Apr 2012 14:06:41 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Nitin Gupta <nitingupta910@gmail.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for Apr 19 (zcache)
References: <20120419164643.d9f918d44c890722b7707508@canb.auug.org.au> <4F909200.6070104@xenotime.net> <0b74f96b-8450-4dfb-8798-36edd0e06a64@default> <4F90E7CA.6080201@linux.vnet.ibm.com> <20120420163745.GB31062@phenom.dumpdata.com>
In-Reply-To: <20120420163745.GB31062@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042019-1780-0000-0000-000004ECC574
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000271; HX=3.00000187; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00132596; UDB=6.00031146; UTC=2012-04-20
 19:08:02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2012 11:37 AM, Konrad Rzeszutek Wilk wrote:
> On Thu, Apr 19, 2012 at 11:36:26PM -0500, Seth Jennings wrote:
>> One fix is this:
>>
>> diff --git a/drivers/staging/zcache/Kconfig b/drivers/staging/zcache/Kconfig
>> index 3ed2c8f..7048e01 100644
>> --- a/drivers/staging/zcache/Kconfig
>> +++ b/drivers/staging/zcache/Kconfig
>> @@ -2,7 +2,7 @@ config ZCACHE
>>         bool "Dynamic compression of swap pages and clean pagecache pages"
>>         # X86 dependency is because zsmalloc uses non-portable pte/tlb
>>         # functions
>> -       depends on (CLEANCACHE || FRONTSWAP) && CRYPTO && X86
>> +       depends on (CLEANCACHE || FRONTSWAP) && CRYPTO=y && X86
>>         select ZSMALLOC
>>         select CRYPTO_LZO
>>         default n
>>
>> I think this is the best way since ZCACHE is a bool and CRYPTO is the only
>> one of the dependencies that is a tristate.  This forces both ZSMALLOC and
>> CRYPTO_LZO to be builtin if ZCACHE is selected.
>>
>> Any other suggestions?
> 
> Could you do:
> 
> default y if (CRYPTO=y || ZSMALLOC=m)
> default m if (CRYPTO=m || ZSMALLOC=y)

ZCACHE is a bool and can't be built as a module.

The requirement is the if ZCACHE=y, then ZSMALLOC and
CRYPTO must also =y.

Thanks,
Seth

