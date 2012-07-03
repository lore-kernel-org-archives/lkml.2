Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933468Ab2GCGdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 02:33:53 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40730 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932967Ab2GCGdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 02:33:51 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FF291BE.7030509@jp.fujitsu.com>
Date: Tue, 03 Jul 2012 15:31:26 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Sha Zhengju <handai.szj@gmail.com>
CC: linux-mm@kvack.org, cgroups@vger.kernel.org, gthelen@google.com,
        yinghan@google.com, akpm@linux-foundation.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH 6/7] memcg: add per cgroup writeback pages accounting
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com> <1340881525-5835-1-git-send-email-handai.szj@taobao.com>
In-Reply-To: <1340881525-5835-1-git-send-email-handai.szj@taobao.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/28 20:05), Sha Zhengju wrote:
> From: Sha Zhengju <handai.szj@taobao.com>
> 
> Similar to dirty page, we add per cgroup writeback pages accounting. The lock
> rule still is:
> 	mem_cgroup_begin_update_page_stat()
> 	modify page WRITEBACK stat
> 	mem_cgroup_update_page_stat()
> 	mem_cgroup_end_update_page_stat()
> 
> There're two writeback interface to modify: test_clear/set_page_writeback.
> 
> Signed-off-by: Sha Zhengju <handai.szj@taobao.com>

Seems good to me. BTW, you named macros as MEM_CGROUP_STAT_FILE_XXX
but I wonder these counters will be used for accounting swap-out's dirty pages..

STAT_DIRTY, STAT_WRITEBACK ? do you have better name ?

Thanks,
-Kame

