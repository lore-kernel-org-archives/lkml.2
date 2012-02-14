Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760728Ab2BNOgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 09:36:42 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:47441 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756648Ab2BNOgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 09:36:39 -0500
Message-ID: <4F3A7121.9010803@linux.vnet.ibm.com>
Date: Tue, 14 Feb 2012 08:35:13 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Marc Dietrich <marvin24@gmx.de>
CC: Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH] staging: fix powerpc linux-next break on zsmalloc
References: <1329144469-8575-1-git-send-email-sjenning@linux.vnet.ibm.com> <4F3A43EC.2030209@gmx.de> <4F3A480C.9090407@gmx.de>
In-Reply-To: <4F3A480C.9090407@gmx.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12021414-1780-0000-0000-00000322EDBB
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000247; HX=3.00000182; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00113710; UDB=6.00027994; UTC=2012-02-14
 14:36:25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2012 05:39 AM, Marc Dietrich wrote:
> Am 14.02.2012 12:22, schrieb Marc Dietrich:
>> Am 13.02.2012 15:47, schrieb Seth Jennings:
>>> linux/vmalloc.h added to zsmalloc-main.c to resolve implicit
>>> declaration errors.
>>>
>>> X86 dependency added to zsmalloc and dependent drivers zcache and zram.
>>>
>>> This X86 only requirement is not ideal.  Working to find portable
>>> functions for __flush_tlb_one and set_pte.
>>
>> sorry, zcache/zram works fine one ARM here. Why not depend on !POWERPC?
> 
> ups, sorry again, I tested an older version only. flush_tlb_one and 
> set_pte is only used with the new allocator as it seems.

It would seem that the cpu-local tlb page flushing function for ARM
is local_flush_tlb_kernel_page(), by look at the kmap_atomic() code
in arch/arm/mm/highmem.c.

So each arch is using a slightly different approach here.

A simple #define per-arch could make a it a common call.  I think
I'm going to code it up and see how it goes.

--
Seth

