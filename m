Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041Ab2ILMzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:55:48 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:58638 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab2ILMzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:55:46 -0400
Message-ID: <50508632.9090003@linux.vnet.ibm.com>
Date: Wed, 12 Sep 2012 20:55:14 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Hugh Dickins <hughd@google.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] thp: tidy and fix khugepaged_prealloc_page
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12091212-6102-0000-0000-00000238A60C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There has a bug in khugepaged_prealloc_page, the page-alloc
indicator is not reset if the previous page request is failed,
then it will trigger the VM_BUG_ON in khugepaged_alloc_page.
It is fixed by the first patch which need not be back port for
it was introduced by recent commit. (sorry for that)

As Hugh pointed out, this are some ugly portions:
- releasing mmap_sem lock is hidden in khugepaged_alloc_page
- page is freed in khugepaged_prealloc_page
The later two patches try to fix these issues.

Hugh,

If any point i missed, please let me know, and sorry to waste
your time on my broken patch.

