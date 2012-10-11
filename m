Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690Ab2JKNk4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 09:40:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:35022 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753616Ab2JKNky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 09:40:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,571,1344236400"; 
   d="scan'208";a="204341801"
From: Andi Kleen <andi@firstfloor.org>
To: ling.ma@intel.com
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] [x86] Optimize copy_page by re-arranging instruction sequence and saving register
References: <1349958548-1868-1-git-send-email-ling.ma@intel.com>
Date: Thu, 11 Oct 2012 06:40:52 -0700
In-Reply-To: <1349958548-1868-1-git-send-email-ling.ma@intel.com> (ling ma's
	message of "Thu, 11 Oct 2012 20:29:08 +0800")
Message-ID: <m2bog9t9cr.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ling.ma@intel.com writes:

> From: Ma Ling <ling.ma@intel.com>
>
> Load and write operation occupy about 35% and 10% respectively
> for most industry benchmarks. Fetched 16-aligned bytes code include 
> about 4 instructions, implying 1.34(0.35 * 4) load, 0.4 write.  
> Modern CPU support 2 load and 1 write per cycle, so throughput from write is
> bottleneck for memcpy or copy_page, and some slight CPU only support one mem
> operation per cycle. So it is enough to issue one read and write instruction
> per cycle, and we can save registers. 

I don't think "saving registers" is a useful goal here.

>
> In this patch we also re-arrange instruction sequence to improve performance
> The performance on atom is improved about 11%, 9% on hot/cold-cache
> case respectively.

That's great, but the question is what happened to the older CPUs that
also this sequence. It may be safer to add a new variant for Atom,
unless you can benchmark those too.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only
