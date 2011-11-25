Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449Ab1KYFnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 00:43:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60951 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab1KYFm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 00:42:59 -0500
Message-ID: <4ECF2AD3.5050801@gmail.com>
Date: Fri, 25 Nov 2011 13:42:43 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, mel@csn.ul.ie
Subject: Question about mm/compaction.c/acct_isolated: computing nr_anon,
 nr_file
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Why does it double the number in line 233/234?
 
 222/* Update the number of anon and file isolated pages in the zone */
 223static void acct_isolated(struct zone *zone, struct compact_control *cc)
 224{
 225        struct page *page;
 226        unsigned int count[NR_LRU_LISTS] = { 0, };
 227
 228        list_for_each_entry(page, &cc->migratepages, lru) {
 229                int lru = page_lru_base_type(page);
 230                count[lru]++;
 231        }
 232
 233        cc->nr_anon = count[LRU_ACTIVE_ANON] + count[LRU_INACTIVE_ANON];
 234        cc->nr_file = count[LRU_ACTIVE_FILE] + count[LRU_INACTIVE_FILE];
 235        __mod_zone_page_state(zone, NR_ISOLATED_ANON, cc->nr_anon);
 236        __mod_zone_page_state(zone, NR_ISOLATED_FILE, cc->nr_file);
 237}

thanks,

