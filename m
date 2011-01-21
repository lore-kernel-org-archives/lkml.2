Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab1AUJ6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 04:58:16 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:40298 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab1AUJ6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 04:58:15 -0500
Date: Fri, 21 Jan 2011 18:56:04 +0900
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        LKLM <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3 -v2] Fix the wrong corrupted page information of
 hugetlb page.
Message-ID: <20110121095604.GC8897@spritzera.linux.bs1.fc.nec.co.jp>
References: <4D38E04A.8050402@np.css.fujitsu.com>
 <20110121051251.GA16406@spritzera.linux.bs1.fc.nec.co.jp>
 <4D394120.3020509@np.css.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <4D394120.3020509@np.css.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 05:17:36PM +0900, Jin Dongming wrote:
> When more than on tail page of the same mapped hugetlb page are
> poisoned at the same time, the sum of corrupted page should be
> the size of one hugetlb page(512 pages). But HardwareCorrupted
> information in /proc/meminfo is 1024 pages or more.
> 
> That is because when the above condition happened,
> __memory_failure() will be called many times and pages in hugetlb
> page are accounted more than one time.
> 
> This patch fixed it by incrementing the number of corrupted page
> one by one.
> 
> -v2 fix checking for "just unpoisoned".
> 
> Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
> Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
