Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab0HJKyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 06:54:31 -0400
Received: from peer.zerties.org ([188.40.33.175]:45843 "EHLO peer.zerties.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757395Ab0HJKy1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 06:54:27 -0400
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: felipe.balbi@nokia.com
Cc: David Howells <dhowells@redhat.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vamos-dev\@i4.informatik.uni-erlangen.de" 
	<vamos-dev@i4.informatik.uni-erlangen.de>
Subject: Re: [PATCH 1/4] arch/frv: Removing dead RAMKERNEL config option
References: <cover.1281431005.git.qy03fugy@stud.informatik.uni-erlangen.de>
	<c80d5af9b2921e9d8cc6d8d7b9a54a882f1c919e.1281431005.git.qy03fugy@stud.informatik.uni-erlangen.de>
	<20100810093717.GD22436@nokia.com>
Date: Tue, 10 Aug 2010 12:54:16 +0200
In-Reply-To: <20100810093717.GD22436@nokia.com> (Felipe Balbi's message of
	"Tue, 10 Aug 2010 12:37:17 +0300")
Message-ID: <864of2ybzb.fsf@peer.zerties.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Balbi <felipe.balbi@nokia.com> writes:

> Hi,
>
> On Tue, Aug 10, 2010 at 11:11:08AM +0200, ext Christian Dietrich wrote:
>>diff --git a/arch/frv/mm/init.c b/arch/frv/mm/init.c
>>index ed64588..73586ad 100644
>>--- a/arch/frv/mm/init.c
>>+++ b/arch/frv/mm/init.c
>>@@ -170,23 +170,6 @@ void __init mem_init(void)
>>  */
>> void free_initmem(void)
>> {
>>-#if defined(CONFIG_RAMKERNEL) && !defined(CONFIG_PROTECT_KERNEL)
>>-	unsigned long start, end, addr;
>>-
>>-	start = PAGE_ALIGN((unsigned long) &__init_begin);	/* round up */
>>-	end   = ((unsigned long) &__init_end) & PAGE_MASK;	/* round down */
>>-
>>-	/* next to check that the page we free is not a partial page */
>>-	for (addr = start; addr < end; addr += PAGE_SIZE) {
>>-		ClearPageReserved(virt_to_page(addr));
>>-		init_page_count(virt_to_page(addr));
>>-		free_page(addr);
>>-		totalram_pages++;
>>-	}
>>-
>>-	printk("Freeing unused kernel memory: %ldKiB freed (0x%lx - 0x%lx)\n",
>>-	       (end - start) >> 10, start, end);
>>-#endif
>> } /* end free_initmem() */
>
> and now you have an empty function... how about removing the function
> completely and it's uses ?

If you take a look at init/main.c:826 free_initmem() is called. perhaps
this can be resolved with a macro, but if anybody in the future wants to
add some functionality there, he won't be happy after grepping.

greetz didi
-- 
(λ x . x x) (λ x . x x) -- See how beatiful the lambda is
No documentation is better than bad documentation
-- Das Ausdrucken dieser Mail wird urheberrechtlich verfolgt.
