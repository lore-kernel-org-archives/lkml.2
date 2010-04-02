Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268Ab0DBObO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 10:31:14 -0400
Received: from waste.org ([173.11.57.241]:33911 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756048Ab0DBObB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 10:31:01 -0400
Date: Fri, 2 Apr 2010 09:30:58 -0500
From: Matt Mackall <mpm@selenic.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       San Mehat <san@google.com>, linux-kernel@vger.kernel.org,
       Brian Swetland <swetland@google.com>, Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, n-horiguchi@ah.jp.nec.com
Subject: Re: [PATCH] proc: pagemap: Hold mmap_sem during page walk
Message-ID: <20100402143058.GA22639@waste.org>
References: <20100401144329.BE42.A69D9226@jp.fujitsu.com> <20100401145509.47f7f1c3.kamezawa.hiroyu@jp.fujitsu.com> <20100401150128.BE45.A69D9226@jp.fujitsu.com> <20100401150956.4f6821c2.kamezawa.hiroyu@jp.fujitsu.com> <20100401153428.d49c6345.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LFD.2.00.1004010747540.3707@i5.linux-foundation.org> <20100402091129.bca35057.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100402091129.bca35057.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 02, 2010 at 09:11:29AM +0900, KAMEZAWA Hiroyuki wrote:

>  	int ret = -ESRCH;
...
> +	pm.len = PM_ENTRY_BYTES * (PAGEMAP_WALK_SIZE >> PAGE_SHIFT);
> +	pm.buffer = kmalloc(pm.len, GFP_TEMPORARY);
> +	if (!pm.buffer)
>  		goto out_mm;
...
>  out_mm:
>  	mmput(mm);

Looks like this gets the wrong return code?

-- 
Mathematics is the supreme nostalgia of our time.
