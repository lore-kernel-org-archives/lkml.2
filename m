Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab2A3Imq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 03:42:46 -0500
Received: from nm4-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.129]:21800 "HELO
	nm4-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753137Ab2A3Imp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 03:42:45 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 558881.11350.bm@omp1005.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=qC3LAiymjr7A+u0pymGPsSjFxQN2GS8g6w7HprbRXSeqzGPMS4+shPyH1vnJnfpfNiYzj6IEtef1GlpeZEf8nOKuBxgGWNIpumjdbQXGQgYLzAZhqXvS6JqCdwWYoM9YY6g9IM4qpqJQ6cgICu6Ma4VSUwMuSTXSJ/oeT3JunQ4=;
X-YMail-OSG: JNCsXMcVM1mvNLa0394rWCLLmi6KGUKpuEbOKWqDyVWX3Xb
 c4tX1fv9OEVu4wSU2zZxGwMNyU.qgFoyNEnBfUfYuwfQFKPiC_8VYZNagFyK
 QUx1XEtmX68uG574k3bx_Om05tQzVDIx1XMDSXx3uDOvpZGhkA2BOB9NhY.W
 191TonjQnDCXNi.rTC0vtaKpuwz.wgtJYP1lFaNjGmmbDzDS6g7khdf0S0JH
 05nW9RBzpcLeTzJKpT4Rheuy_nd9tqF9HjvE6hgw6jx.W2uTgDLpVq_hNUyd
 54QXDZdrCdY1FLyYI8dJPmTTwEeHOkfiVA5YV..JqF94mt0B5WiBL2eDnNvt
 0ehqpoTA.YUjQpGVfXbHhkiRln6eC4Yu0eegnDzQsebMJvA9ibtkvt5EZ_.h
 B.LIZsOW8NYWKOrsQsNngZScfwl0XdRAMIWch.AFG_CjaA7A8pLRTm5B72iW
 ciYxmFF6IEne9ZGUrAm2UtSufUIkJhSxO4bVCJEtEZ76.sMFeV3ZCrL0-
X-Mailer: YahooMailWebService/0.8.116.331537
References: <1327310360.96918.YahooMailNeo@web162003.mail.bf1.yahoo.com> <1327313719.76517.YahooMailNeo@web162002.mail.bf1.yahoo.com> <alpine.LSU.2.00.1201231125200.1677@eggly.anvils> <1327468926.52380.YahooMailNeo@web162002.mail.bf1.yahoo.com> <alpine.LSU.2.00.1201251623340.2141@eggly.anvils>
Message-ID: <1327912964.12941.YahooMailNeo@web162006.mail.bf1.yahoo.com>
Date: Mon, 30 Jan 2012 00:42:44 -0800 (PST)
From: PINTU KUMAR <pintu_agarwal@yahoo.com>
Reply-To: PINTU KUMAR <pintu_agarwal@yahoo.com>
Subject: Re: [Help] : RSS/PSS showing 0 during smaps for Xorg
To: Hugh Dickins <hughd@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <alpine.LSU.2.00.1201251623340.2141@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Hugh Dickins,
 
Thank you very much for your reply.
 
>If these are ordinary pages with struct pages, then you could probably
>use a loop of vm_insert_page()s to insert them at mmap time, or a fault
>routine to insert them on fault.  But as I said, I don't know if this
>memory is part of the ordinary page pool or not.
 
You suggestion about using vm_insert_page() instead of remap_pfn_range worked for me and I got the Rss/Pss information for my driver.
But still there is one problem related to page fault. 
If I remove remap_pfn_range then I get a page fault in the beginning. 
I tried to use the same vm_insert_page() during page_fault_handler for each vmf->virtual_address but it did not work.
So for time being I remove the page fault handler from my vm_operations.
But with these my menu screen(LCD screen) is not behaving properly (I get colorful lines on my LCD).
So I need to handle the page fault properly.
 
But I am not sure what is that I need to do inside page fault handler. Do you have any example or references or suggestions?
 
 
>Really, the question has to be, why do you need to see non-0s there?
I want Rss/Pss value to account for how much video memory is used by the driver for the menu-screen,Xorg processes.
 
 
 
Thanks,
Pintu
 

>________________________________
>From: Hugh Dickins <hughd@google.com>
>To: PINTU KUMAR <pintu_agarwal@yahoo.com> 
>Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>; "linux-mm@kvack.org" <linux-mm@kvack.org> 
>Sent: Thursday, 26 January 2012 6:29 AM
>Subject: Re: [Help] : RSS/PSS showing 0 during smaps for Xorg
>
>On Tue, 24 Jan 2012, PINTU KUMAR wrote:
>>  
>> Is there a way to convert our mapped pages to a normal pages. I tried pfn_to_page() but no effect.
>> I mean the page is considered normal only if it is associated with "struct page" right???
>> Is is possible to convert these pages to a normal struct pages so that we can get the Rss/Pss value??
>
>I don't understand why you are so anxious to see non-0 numbers there.
>
>I don't know if the pages you are mapping with remap_pfn_range() are
>ordinary pages in normal memory, and so already have struct pages, or not.
>
>>  
>> Also, the VM_PFNMAP is being set for all dirvers during remap_pfn_range and stills shows Rss/Pss for other drivers.
>
>I'm surprised.  It is possible to set up a private-writable VM_PFNMAP area,
>which can then contain ordinary private copies of the underlying pages,
>and these copies will count to Rss.  But I thought that was very unusual.
>
>You don't mention which drivers these are that use remap_pfn_range yet
>show Rss (and I don't particularly want to spend time researching them).
>
>I can see three or four places in drivers/ where VM_PFNMAP is set,
>perhaps without going through remap_pfn_range(): that seems prone
>to error, I wouldn't recommend going that route.
>
>> Then why it is not shown for our driver?
>> How to avoid remap_pfn_range to not to set VM_PFNMAP for our driver?
>
>If these are ordinary pages with struct pages, then you could probably
>use a loop of vm_insert_page()s to insert them at mmap time, or a fault
>routine to insert them on fault.  But as I said, I don't know if this
>memory is part of the ordinary page pool or not.
>
>Really, the question has to be, why do you need to see non-0s there?
>
>Hugh
>
>
