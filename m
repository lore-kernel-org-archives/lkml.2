Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab1ANXQE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 18:16:04 -0500
Received: from xenotime.net ([72.52.115.56]:45740 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752371Ab1ANXQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 18:16:03 -0500
Message-ID: <4D30D92F.20106@xenotime.net>
Date: Fri, 14 Jan 2011 15:15:59 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Meelis Roos <mroos@linux.ee>
CC: linux-parisc@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: compile failure on hppa64: pte_mkwrite
References: <alpine.SOC.1.00.1101150057210.8462@math.ut.ee>
In-Reply-To: <alpine.SOC.1.00.1101150057210.8462@math.ut.ee>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/11 14:59, Meelis Roos wrote:
> Tried todays 2.6.37+git on hppa64 and it fail to compile:
> 
>   CC      arch/parisc/kernel/asm-offsets.s
> In file included from /home/mroos/linux-2.6/arch/parisc/include/asm/pgtable.h:13,
>                  from arch/parisc/kernel/asm-offsets.c:37:
> include/linux/mm.h: In function 'maybe_mkwrite':
> include/linux/mm.h:482: error: implicit declaration of function 'pte_mkwrite'
> include/linux/mm.h:482: error: incompatible types when assigning to type 'pte_t' from type 'int'
> In file included from arch/parisc/kernel/asm-offsets.c:37:
> /home/mroos/linux-2.6/arch/parisc/include/asm/pgtable.h: At top level:
> /home/mroos/linux-2.6/arch/parisc/include/asm/pgtable.h:338: error: conflicting types for 'pte_mkwrite'
> include/linux/mm.h:482: note: previous implicit declaration of 'pte_mkwrite' was here
> make[1]: *** [arch/parisc/kernel/asm-offsets.s] Error 1
> make: *** [prepare0] Error 2
> 
> It seems pte_mkwrite is referenced in mm.h but not defined anywhere in 
> include directory.
> 

James posted a patch:

http://marc.info/?l=linux-parisc&m=129504371532124&w=2

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
