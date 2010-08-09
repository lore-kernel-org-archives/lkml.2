Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab0HIN4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 09:56:17 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:40660 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425Ab0HIN4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 09:56:16 -0400
Message-ID: <4C6008EA.8040601@austin.ibm.com>
Date: Mon, 09 Aug 2010 08:55:54 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        Greg KH <greg@kroah.com>, Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/9] v4  Add mutex for add/remove of memory blocks
References: <4C581A6D.9030908@austin.ibm.com>	<4C581C26.5080007@austin.ibm.com> <20100805135314.7229d07c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100805135314.7229d07c.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2010 11:53 PM, KAMEZAWA Hiroyuki wrote:
> On Tue, 03 Aug 2010 08:39:50 -0500
> Nathan Fontenot <nfont@austin.ibm.com> wrote:
> 
>> Add a new mutex for use in adding and removing of memory blocks.  This
>> is needed to avoid any race conditions in which the same memory block could
>> be added and removed at the same time.
>>
>> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> But a nitpick (see below)
> 
>> ---
>>  drivers/base/memory.c |    9 +++++++++
>>  1 file changed, 9 insertions(+)
>>
>> Index: linux-2.6/drivers/base/memory.c
>> ===================================================================
>> --- linux-2.6.orig/drivers/base/memory.c	2010-08-02 13:35:00.000000000 -0500
>> +++ linux-2.6/drivers/base/memory.c	2010-08-02 13:45:34.000000000 -0500
>> @@ -27,6 +27,8 @@
>>  #include <asm/atomic.h>
>>  #include <asm/uaccess.h>
>>  
>> +static struct mutex mem_sysfs_mutex;
>> +
> 
> For static symbol of mutex, we usually do
> 	static DEFINE_MUTEX(mem_sysfs_mutex);
> 
> Then, extra calls of mutex_init() is not required.
> 

ok,  fixed in the next version of the patches.

-Nathan
