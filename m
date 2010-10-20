Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab0JTRV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 13:21:26 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24144 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab0JTRVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 13:21:25 -0400
Message-ID: <4CBF2501.4030704@oracle.com>
Date: Wed, 20 Oct 2010 10:21:05 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, xen-devel@lists.xensource.com,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for October 20 (xen)
References: <20101020162053.5595e1bf.sfr@canb.auug.org.au> <20101020092836.e225cfc3.randy.dunlap@oracle.com> <20101020170932.GB23458@dumpdata.com>
In-Reply-To: <20101020170932.GB23458@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/10 10:09, Konrad Rzeszutek Wilk wrote:
> On Wed, Oct 20, 2010 at 09:28:36AM -0700, Randy Dunlap wrote:
>> On Wed, 20 Oct 2010 16:20:53 +1100 Stephen Rothwell wrote:
>>
>>> Hi all,
>>>
>>> Changes since 20101019:
>>>
>>>
>>> The swiotlb-xen tree gained a conflict against the pci tree.
>>
>>
>> linux-next-20101020/drivers/xen/biomerge.c: In function 'xen_biovec_phys_mergeable':
>> linux-next-20101020/drivers/xen/biomerge.c:8: error: dereferencing pointer to incomplete type
>> linux-next-20101020/drivers/xen/biomerge.c:9: error: dereferencing pointer to incomplete type
>> linux-next-20101020/drivers/xen/biomerge.c:11: error: implicit declaration of function '__BIOVEC_PHYS_MERGEABLE'
> 
> Ok, this patch fixes it. I am sticking it in my tree:

Ack.  Thanks.

> From 2d7d06dd8ffcbafc03bf2c1cb4b2fb2c4c405ec1 Mon Sep 17 00:00:00 2001
> From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Date: Wed, 20 Oct 2010 13:04:13 -0400
> Subject: [PATCH] xen: Update Makefile with CONFIG_BLOCK dependency for biomerge.c
> 
> Without this dependency we get these compile errors:
> 
> linux-next-20101020/drivers/xen/biomerge.c: In function 'xen_biovec_phys_mergeable':
> linux-next-20101020/drivers/xen/biomerge.c:8: error: dereferencing pointer to incomplete type
> linux-next-20101020/drivers/xen/biomerge.c:9: error: dereferencing pointer to incomplete type
> linux-next-20101020/drivers/xen/biomerge.c:11: error: implicit declaration of function '__BIOVEC_PHYS_MERGEABLE'
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/xen/Makefile |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
> index b47f5da..b978645 100644
> --- a/drivers/xen/Makefile
> +++ b/drivers/xen/Makefile
> @@ -1,9 +1,10 @@
> -obj-y	+= grant-table.o features.o events.o manage.o biomerge.o
> +obj-y	+= grant-table.o features.o events.o manage.o
>  obj-y	+= xenbus/
>  
>  nostackp := $(call cc-option, -fno-stack-protector)
>  CFLAGS_features.o			:= $(nostackp)
>  
> +obj-$(CONFIG_BLOCK)		+= biomerge.o
>  obj-$(CONFIG_HOTPLUG_CPU)	+= cpu_hotplug.o
>  obj-$(CONFIG_XEN_XENCOMM)	+= xencomm.o
>  obj-$(CONFIG_XEN_BALLOON)	+= balloon.o


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
