Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291Ab2AYFWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 00:22:09 -0500
Received: from nm12.bullet.mail.bf1.yahoo.com ([98.139.212.171]:46998 "HELO
	nm12.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750812Ab2AYFWI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 00:22:08 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 415543.75490.bm@omp1048.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=YXUjSNR8I1I16+vHeNtp/76/BLLSqih69f3skEDvxKDalyj88R1cAisTa0E50hlOQKCMW44Qc6QueyxLrMCTBejbckg604bkfsSV5ZfxsTSmeiWSZA2aijBjAL6vsFBT6h4GGYaZ6zqZoxn+sgXlWHAmmCumQXR3ccNU2Od2FW8=;
X-YMail-OSG: VZ.9OnUVM1lsq3xv5tY4_4QklfI5Qjzj4_nNzHBoC2ftl4s
 XtVFJmlp0dfGkM9.uuI1jvismE5a2jQdz4O8xJA3OKit2PbEOPDstZtXEE0l
 tUVmbgMTa88vSQRGKlLVEdmvPPmON5HRp7BrPb.Kjwrz7CJELTLjOf829xvb
 T0XEh7swxmpxgwhXjtMHijMV77gEO8T2FkcWTt6p3jIt7cKojJLvsrHf77aC
 a51n6RS962bLR_iGDs7yaynyiC.Iwe3Wrudq4gdPLw1e8OkmEKHMpL5O9v3w
 c_8veSyraNyzglcX1eVf_kcAiwCZaxVPnwZXH0kKogpuIefHd0LCT5awfhsw
 nS2GdI9_ppEi2N_nyjzSrXFCMxOGmIwZaohw6v8ORFGfBvu4uvXFqLbdrbnK
 uVZUZZBbv5krZz48TvIp3UY1DmrcX_i_ah8PJf41lolyk1ES3.d4ouuCZ9BH
 eRQ0uXSDtXYjW.rAAqBi5o4tm8WHBcGUuNzDxbm20QvMbcdVx5Xi0D9re
X-Mailer: YahooMailWebService/0.8.116.331537
References: <1327310360.96918.YahooMailNeo@web162003.mail.bf1.yahoo.com> <1327313719.76517.YahooMailNeo@web162002.mail.bf1.yahoo.com> <alpine.LSU.2.00.1201231125200.1677@eggly.anvils>
Message-ID: <1327468926.52380.YahooMailNeo@web162002.mail.bf1.yahoo.com>
Date: Tue, 24 Jan 2012 21:22:06 -0800 (PST)
From: PINTU KUMAR <pintu_agarwal@yahoo.com>
Reply-To: PINTU KUMAR <pintu_agarwal@yahoo.com>
Subject: Re: [Help] : RSS/PSS showing 0 during smaps for Xorg
To: Hugh Dickins <hughd@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <alpine.LSU.2.00.1201231125200.1677@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

________________________________
>From: Hugh Dickins <hughd@google.com>
>To: PINTU KUMAR <pintu_agarwal@yahoo.com> 
>Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>; "linux-mm@kvack.org" <linux-mm@kvack.org> 
>Sent: Tuesday, 24 January 2012 1:01 AM
>Subject: Re: [Help] : RSS/PSS showing 0 during smaps for Xorg
>
>On Mon, 23 Jan 2012, PINTU KUMAR wrote:
>> Dear All,
>> 
>> I am facing one problem for one of my kernel module for our linux mobile with kernel2.6.36.
>> 
>> When I do cat /proc/<Xorg pid>/smaps | grep -A 11 /dev/ump , to track information for my ump module,
>> we always get Rss/Pss as 0 kB as shown below:
>> cat /proc/1731/smaps | grep -A 11 /dev/ump
>> 414db000-415ff000 rw-s 00015000 00:12 6803       /dev/ump
>> Size:               1168 kB
>> Rss:                   0 kB
>> Pss:                   0 kB
>> track_rss_value = 0, iswalkcalled = 1, smap_pte_range_called = 1, swap_pte = 0, not_pte_present = 0, not_normal_page = 1
>> isspecial = 0, not_special = 1, isMixedMap = 0, pfnpages_null = 0, pfnoff_flag = 0, not_cow_mapping = 1, normal_page_end = 0
>>  
>> After tracing down the problem, I found out that during "show_smaps" in fs/proc/task_mmu.c and during call to smaps_pte_range the vm_normal_page() is always returning NULL for our /dev/ump driver.
>> (smaps_pte_range() is the place where Rss/Pss information is populated)
>> Thus mss->resident (Rss value) is never getting incremented.  
>>  
>> To trace the problem I added few flags during show_smaps & vm_normal_page() as shown above. The value of 1 indicates that the condition is executed.
>> Thus "normal_page_end" indicates that the "vm_normal_page" has never ended successfully and always returns from 
>> "!is_cow_mapping()".
>>  
>> So, I wanted to know the main cause for vm_normal_page() always returning NULL page for our ump driver. 
>> What is that I am missing in my driver ?
>>  
>> Can anyone please let me know what could be the problem in our driver.
>
>This not evidence of any problem in your driver.
>
>vm_normal_page() returns NULL because the pages mapped by your driver
>are not normal faultable and reclaimable pages, but an area of physical
>memory mapped in by remap_pfn_range(), which sets the VM_PFNMAP flag.
>
>The mm subsystem does not count such pages towards rss (or pss),
>hence your 0s.
>
>Hugh
>

Dear Mr. Hugh,
 
Thank you very much for your reply.
Is there a way to convert our mapped pages to a normal pages. I tried pfn_to_page() but no effect.
I mean the page is considered normal only if it is associated with "struct page" right???
Is is possible to convert these pages to a normal struct pages so that we can get the Rss/Pss value??
 
Also, the VM_PFNMAP is being set for all dirvers during remap_pfn_range and stills shows Rss/Pss for other drivers.
Then why it is not shown for our driver?
How to avoid remap_pfn_range to not to set VM_PFNMAP for our driver?
 
Please let me know.
 
 
 
Thanks, Regards,
Pintu
