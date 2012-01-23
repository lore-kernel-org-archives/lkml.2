Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab2AWKPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 05:15:22 -0500
Received: from nm24.bullet.mail.bf1.yahoo.com ([98.139.212.183]:42196 "HELO
	nm24.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752037Ab2AWKPV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 05:15:21 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 48701.88882.bm@omp1043.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=yxn9sYwYJow2VIIGPcOC8xE7lAK4Eqkaihx01pP2X5Gkip8u0u5R5qEy1ix4fpy8uzdtN9xTlieqO3SPdjfeAnUmSBFcR9ao4cp9rQdkaM7pguC2xgXt4VuBreDxlwAO0gOibfmjpWqZdBVRdLqJg6OqnzrDt1pSMYrvuEBxsBg=;
X-YMail-OSG: KMndtuYVM1nco73f2urxEbeZ4BUD8JCVVG45O0oErL7cPTP
 loqz.hhC36Hs2ESeW5yB4gEPAQA7iZpzGKFFzkltO4hzMCGN0uIZCiJBGX31
 tu_BPtdkwiOlnTkYIMB_q7vpARtqobxSczqZ7yXa.WIlc1GVCRG8h6zGQr18
 AQb0PJLANQOi4XnPJfwyhcQzJZv999y0a7syfz204UHLUcIOOPULStr1KCdx
 t3NlRAS8J1CXMi5mVV_3QSi08XSLOWKYrh1isgEEx.7dwKxcpTUzPSNxWzEI
 zTO67TR7sPOEhcK4S2tlro15.x78w3GaFG0zX5EyNNdnUhIOBcendamDQMFI
 oIrJjXZBXcu_9wlYnHTk2B.mDDqmbsmID4Z3if137zECOWjCheK_YmkIa5q.
 M7BRCKlidJA.AOmD1Bqf27nLb09fhbY.RKUyO9EJICyk1kv7h28bwLNdoS6u
 uyozY4YeTZLC4iA1FaarRD..EsiUy2JwPXQwm7bZESAy.wuQgbWq3mw--
X-Mailer: YahooMailWebService/0.8.116.331537
References: <1327310360.96918.YahooMailNeo@web162003.mail.bf1.yahoo.com>
Message-ID: <1327313719.76517.YahooMailNeo@web162002.mail.bf1.yahoo.com>
Date: Mon, 23 Jan 2012 02:15:19 -0800 (PST)
From: PINTU KUMAR <pintu_agarwal@yahoo.com>
Reply-To: PINTU KUMAR <pintu_agarwal@yahoo.com>
Subject: [Help] : RSS/PSS showing 0 during smaps for Xorg
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <1327310360.96918.YahooMailNeo@web162003.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

I am facing one problem for one of my kernel module for our linux mobile with kernel2.6.36.

When I do cat /proc/<Xorg pid>/smaps | grep -A 11 /dev/ump , to track information for my ump module,
we always get Rss/Pss as 0 kB as shown below:
cat /proc/1731/smaps | grep -A 11 /dev/ump
414db000-415ff000 rw-s 00015000 00:12 6803       /dev/ump
Size:               1168 kB
Rss:                   0 kB
Pss:                   0 kB
track_rss_value = 0, iswalkcalled = 1, smap_pte_range_called = 1, swap_pte = 0, not_pte_present = 0, not_normal_page = 1
isspecial = 0, not_special = 1, isMixedMap = 0, pfnpages_null = 0, pfnoff_flag = 0, not_cow_mapping = 1, normal_page_end = 0
 
After tracing down the problem, I found out that during "show_smaps" in fs/proc/task_mmu.c and during call to smaps_pte_range the vm_normal_page() is always returning NULL for our /dev/ump driver.
(smaps_pte_range() is the place where Rss/Pss information is populated)
Thus mss->resident (Rss value) is never getting incremented.  
 
To trace the problem I added few flags during show_smaps & vm_normal_page() as shown above. The value of 1 indicates that the condition is executed.
Thus "normal_page_end" indicates that the "vm_normal_page" has never ended successfully and always returns from 
"!is_cow_mapping()".
 
So, I wanted to know the main cause for vm_normal_page() always returning NULL page for our ump driver. 
What is that I am missing in my driver ?
 
Can anyone please let me know what could be the problem in our driver.
 
Thanks.
 
With Regards,
Pintu
