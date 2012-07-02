Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab2GBLQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 07:16:25 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45408 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab2GBLQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 07:16:23 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FF1827A.7060806@jp.fujitsu.com>
Date: Mon, 02 Jul 2012 20:14:02 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Sha Zhengju <handai.szj@gmail.com>
CC: linux-mm@kvack.org, cgroups@vger.kernel.org, gthelen@google.com,
        yinghan@google.com, akpm@linux-foundation.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH 3/7] Make TestSetPageDirty and dirty page accounting in
 one func
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com> <1340881275-5651-1-git-send-email-handai.szj@taobao.com>
In-Reply-To: <1340881275-5651-1-git-send-email-handai.szj@taobao.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/28 20:01), Sha Zhengju wrote:
> From: Sha Zhengju <handai.szj@taobao.com>
> 
> Commit a8e7d49a(Fix race in create_empty_buffers() vs __set_page_dirty_buffers())
> extracts TestSetPageDirty from __set_page_dirty and is far away from
> account_page_dirtied.But it's better to make the two operations in one single
> function to keep modular.So in order to avoid the potential race mentioned in
> commit a8e7d49a, we can hold private_lock until __set_page_dirty completes.
> I guess there's no deadlock between ->private_lock and ->tree_lock by quick look.
> 
> It's a prepare patch for following memcg dirty page accounting patches.
> 
> Signed-off-by: Sha Zhengju <handai.szj@taobao.com>

I think there is no problem with the lock order.

My small concern is the impact on the performance. IIUC, lock contention here can be
seen if multiple threads write to the same file in parallel.
Do you have any numbers before/after the patch ?


Thanks,
-Kmae

