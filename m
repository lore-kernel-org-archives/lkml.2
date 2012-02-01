Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab2BAOzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 09:55:20 -0500
Received: from nm14-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.164]:23510 "HELO
	nm14-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754668Ab2BAOzS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 09:55:18 -0500
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Feb 2012 09:55:18 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 921084.7182.bm@omp1048.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=xAsIUa6OLi3ZKGEbl4Odv5OF211MPE2CkyS4d+o0iy3lOLXDTAHeiFeWlYlgh0QN4IzYydBqdUGO89y0YL0+iKmiWNymWEySthJH5NptUUA7Wq3UAx07MpQwpeTRyAY5doZledgbb2czpEGeO+dr2nlElApSs4skqN8HNx41U5c=;
X-YMail-OSG: gThlXMYVM1nvBbzBVDowaKCy1CAPWx9bFK0W4VOATZvqFgd
 obRveig89pHpk8bDz_Wlxwbs2UdukxANnNsIAUBlQjc212WraUaOVWQi1dqB
 lpJKBN6qlvapqRPccI4evmyNfoZKZWaK7vl9o83vVB0kFiSBNCPTmsyhHztx
 hi4nJTZlCHkNZPAHyDC_ez1g2P.mos1yqQ6TnFfPVJFqJK8NvUfkpyylUiyl
 pKv7Ecgq8WKroOOMZGWwqd_535hmlVcixsd9R.6gQXRc2OQ7g_GzUPPXGcrV
 MXKzcwzSiKH8KZkhRUnsXieELG6u2Umi86IoRvqvLzOFBdFwCVIbbZW7bdla
 5cM3Ag8D8YCCu_HpMqndSc_9R.2P13HSrqtJ.p3TKb8d4EpdzdXE6SxPzjle
 i3DQhlLw4KH9a8VM4za_E3IV9Rll.i9VbcKY7XDIXBke2yYgbs3QwgJ65GrD
 bkCPRvcExtN1Cybd.Joyb77O.WYjhfGkeH9Y1DUx0QmP9Mmmcnfxu
X-Mailer: YahooMailWebService/0.8.116.331537
References: <1327310360.96918.YahooMailNeo@web162003.mail.bf1.yahoo.com> <1327313719.76517.YahooMailNeo@web162002.mail.bf1.yahoo.com> <alpine.LSU.2.00.1201231125200.1677@eggly.anvils> <1327468926.52380.YahooMailNeo@web162002.mail.bf1.yahoo.com> <alpine.LSU.2.00.1201251623340.2141@eggly.anvils> <1327912964.12941.YahooMailNeo@web162006.mail.bf1.yahoo.com> <alpine.LSU.2.00.1201301034100.1884@eggly.anvils>
Message-ID: <1328107758.5077.YahooMailNeo@web162002.mail.bf1.yahoo.com>
Date: Wed, 1 Feb 2012 06:49:18 -0800 (PST)
From: PINTU KUMAR <pintu_agarwal@yahoo.com>
Reply-To: PINTU KUMAR <pintu_agarwal@yahoo.com>
Subject: Re: [Help] : RSS/PSS showing 0 during smaps for Xorg
To: Hugh Dickins <hughd@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <alpine.LSU.2.00.1201301034100.1884@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Hugh,
 
Thank you for your help/suggestion so far.
 
Please find further updates on this below.
 
>Sounds like you're not using vm_insert_page() properly: I would not expect
>you to get a page fault there once you've set up the area with a loop of
>vm_insert_page()s.
>perhaps you're mapping less than you need to.

1)  The page fault is not occuring now after calling vm_insert_page() in a loop for every page. The hint about "mapping less than you need to" stricked me. Please check the snapshot below.
     loop
        vm_insert_page(vma,start,page);
        start = start + PAGE_SIZE;
        size = size - PAGE_SIZE;
    until size > 0
 
    I verified other drivers in kernel code and found this is how it is done.
 
2)  But after doing all this also my menu-screen is not proper. Still I am getting colorful lines on the menu-screen.
     Can you point me out what could be the problem??
 
 
 
Thanks, Regards,
Pintu
 
 
>________________________________
>From: Hugh Dickins <hughd@google.com>
>To: PINTU KUMAR <pintu_agarwal@yahoo.com> 
>Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>; "linux-mm@kvack.org" <linux-mm@kvack.org> 
>Sent: Tuesday, 31 January 2012 12:19 AM
>Subject: Re: [Help] : RSS/PSS showing 0 during smaps for Xorg
>
>On Mon, 30 Jan 2012, PINTU KUMAR wrote:
>>  
>> >If these are ordinary pages with struct pages, then you could probably
>> >use a loop of vm_insert_page()s to insert them at mmap time, or a fault
>> >routine to insert them on fault.  But as I said, I don't know if this
>> >memory is part of the ordinary page pool or not.
>>  
>> You suggestion about using vm_insert_page() instead of remap_pfn_range worked for me and I got the Rss/Pss information for my driver.
>
>Oh, I'm glad that happened to work for you.
>
>> But still there is one problem related to page fault. 
>> If I remove remap_pfn_range then I get a page fault in the beginning. 
>> I tried to use the same vm_insert_page() during page_fault_handler for each vmf->virtual_address but it did not work.
>> So for time being I remove the page fault handler from my vm_operations.
>> But with these my menu screen(LCD screen) is not behaving properly (I get colorful lines on my LCD).
>> So I need to handle the page fault properly.
>>  
>> But I am not sure what is that I need to do inside page fault handler. Do you have any example or references or suggestions?
>
>Sounds like you're not using vm_insert_page() properly: I would not expect
>you to get a page fault there once you've set up the area with a loop of
>vm_insert_page()s.
>
>Check the comments above it in mm/memory.c ("Your vma protection will
>have to be set up correctly" might be relevant).
>
>Compare how you're using it with other users of vm_insert_page() in
>the kernel tree.  Sorry, I don't have time to do your debugging.
>
>>  
>> >Really, the question has to be, why do you need to see non-0s there?
>> I want Rss/Pss value to account for how much video memory is used by the driver for the menu-screen,Xorg processes.
>
>So, userspace does an mmap for a large-enough window, but only some part of
>that is filled by the driver (whether by remap_pfn_range or vm_insert_pages),
>and you'd like to communicate back how much via the Rss, instead of adding
>some ioctl or sysfs interface to the driver?  Fair enough.
>
>I expect userspace could also work it out by touching pages of the area
>until it gets a SIGBUS, but that might be too dirty a way of finding out.
>
>Hmm, SIGBUS: maybe that's related to the faults that are puzzling you:
>perhaps you're mapping less than you need to.
>
>Hugh
>
>
