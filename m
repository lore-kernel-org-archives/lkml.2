Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466Ab0HJJjr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 05:39:47 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:19567 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab0HJJjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 05:39:44 -0400
Date: Tue, 10 Aug 2010 12:37:17 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Cc: David Howells <dhowells@redhat.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vamos-dev@i4.informatik.uni-erlangen.de" 
	<vamos-dev@i4.informatik.uni-erlangen.de>
Subject: Re: [PATCH 1/4] arch/frv: Removing dead RAMKERNEL config option
Message-ID: <20100810093717.GD22436@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <cover.1281431005.git.qy03fugy@stud.informatik.uni-erlangen.de>
 <c80d5af9b2921e9d8cc6d8d7b9a54a882f1c919e.1281431005.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <c80d5af9b2921e9d8cc6d8d7b9a54a882f1c919e.1281431005.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 10, 2010 at 11:11:08AM +0200, ext Christian Dietrich wrote:
>diff --git a/arch/frv/mm/init.c b/arch/frv/mm/init.c
>index ed64588..73586ad 100644
>--- a/arch/frv/mm/init.c
>+++ b/arch/frv/mm/init.c
>@@ -170,23 +170,6 @@ void __init mem_init(void)
>  */
> void free_initmem(void)
> {
>-#if defined(CONFIG_RAMKERNEL) && !defined(CONFIG_PROTECT_KERNEL)
>-	unsigned long start, end, addr;
>-
>-	start = PAGE_ALIGN((unsigned long) &__init_begin);	/* round up */
>-	end   = ((unsigned long) &__init_end) & PAGE_MASK;	/* round down */
>-
>-	/* next to check that the page we free is not a partial page */
>-	for (addr = start; addr < end; addr += PAGE_SIZE) {
>-		ClearPageReserved(virt_to_page(addr));
>-		init_page_count(virt_to_page(addr));
>-		free_page(addr);
>-		totalram_pages++;
>-	}
>-
>-	printk("Freeing unused kernel memory: %ldKiB freed (0x%lx - 0x%lx)\n",
>-	       (end - start) >> 10, start, end);
>-#endif
> } /* end free_initmem() */

and now you have an empty function... how about removing the function 
completely and it's uses ?

-- 
balbi

DefectiveByDesign.org
