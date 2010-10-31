Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab0JaDjF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 23:39:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:60328 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753642Ab0JaDjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 23:39:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,266,1286175600"; 
   d="scan'208";a="342593692"
Subject: Re: [PATCH] x86: Use online node real index in
 calulate_tbl_offset()
From: Shaohua Li <shaohua.li@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4CCA2F0C.7010302@kernel.org>
References: <4CCA2F0C.7010302@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 31 Oct 2010 11:38:59 +0800
Message-ID: <1288496339.1945.2.camel@shli-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-29 at 10:18 +0800, Yinghai Lu wrote:
> Found one numa system that doesn't have ram installed in first socket
> hang during executing init scripts.
> 
> bisect to:
> 
> |commit 932967202182743c01a2eee4bdfa2c42697bc586
> |Author: Shaohua Li <shaohua.li@intel.com>
> |Date:   Wed Oct 20 11:07:03 2010 +0800
> |
> |    x86: Spread tlb flush vector between nodes
> 
> It turns out when first socket is not online could have cpus on node1
> tlb_offset set to bigger than NUM_INVALIDATE_TLB_VECTORS.
> 
> that could affect systems like 4 sockets, but socket 2 doesn't
> have installed, sockets 3 will get too big tlb_offset.
> 
> Need to use real online node idx.
> 
Thanks for catching it up.

Acked-by: Shaohua Li <shaohua.li@intel.com>

