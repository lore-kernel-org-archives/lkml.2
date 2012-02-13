Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab2BMOPQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 09:15:16 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:52247 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab2BMOPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 09:15:14 -0500
Message-ID: <4F391A98.3080400@linux.vnet.ibm.com>
Date: Mon, 13 Feb 2012 08:13:44 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>
Subject: Re: linux-next: build failure after merge of the final tree (staging
 tree related)
References: <20120213171949.262e0c12e8d8883e90216df1@canb.auug.org.au> <20120213064508.GD28617@kroah.com>
In-Reply-To: <20120213064508.GD28617@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12021314-6148-0000-0000-0000036507D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2012 12:45 AM, Greg KH wrote:
> On Mon, Feb 13, 2012 at 05:19:49PM +1100, Stephen Rothwell wrote:
>> Hi ,
>>
>> After merging the final tree, today's linux-next build (powerpc allyesconfig)
>> failed like this:
>>
>> drivers/staging/zsmalloc/zsmalloc-main.c: In function 'zs_cpu_notifier':
>> drivers/staging/zsmalloc/zsmalloc-main.c:451:3: error: implicit declaration of function 'alloc_vm_area' [-Werror=implicit-function-declaration]
>> drivers/staging/zsmalloc/zsmalloc-main.c:451:12: warning: assignment makes pointer from integer without a cast [enabled by default]
>> drivers/staging/zsmalloc/zsmalloc-main.c:459:4: error: implicit declaration of function 'free_vm_area' [-Werror=implicit-function-declaration]
>> drivers/staging/zsmalloc/zsmalloc-main.c: In function 'zs_map_object':
>> drivers/staging/zsmalloc/zsmalloc-main.c:705:3: error: implicit declaration of function 'set_pte' [-Werror=implicit-function-declaration]
>> drivers/staging/zsmalloc/zsmalloc-main.c:709:27: error: dereferencing pointer to incomplete type
>> drivers/staging/zsmalloc/zsmalloc-main.c: In function 'zs_unmap_object':
>> drivers/staging/zsmalloc/zsmalloc-main.c:739:3: error: implicit declaration of function '__flush_tlb_one' [-Werror=implicit-function-declaration]
>>
>> Caused by commit 61989a80fb3a ("staging: zsmalloc: zsmalloc memory
>> allocation library").  This needs to include linux/vmalloc.h at least.  I
>> couldn't find set_pte at all or __flush_tlb_one for powerpc.
>>
>> This was too hard to revert, so I have left powerpc allyesconfig broken
>> for today.  I may revert it (and some dependent commits) tomorrow.
> 
> Nitin, please send me a patch to fix this as soon as possible.

Hey Greg,

Working... response within the hour.

--
Seth

