Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665Ab2HMLM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 07:12:56 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:45681 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab2HMLMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 07:12:52 -0400
Message-ID: <5028E12C.70101@linux.vnet.ibm.com>
Date: Mon, 13 Aug 2012 19:12:44 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andrea Arcangeli <aarcange@redhat.com>, Hugh Dickins <hughd@google.com>,
        David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [PATCH 00/12] thp: optimize use of khugepaged_mutex and dependence
 of CONFIG_NUMA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12081311-5816-0000-0000-000003F8C5DD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

khugepaged_mutex is used very complexly and there are too many small pieces
of the code depend on CONFIG_NUMA, they make the code very hardly understand

This patchset try to optimize use of khugepaged_mutex and reduce dependence
of CONFIG_NUMA, after the patchset, the code is more readable

