Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab2FMO47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 10:56:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:35919 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516Ab2FMO45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 10:56:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="179480471"
Date: Wed, 13 Jun 2012 07:56:56 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Alex Shi <alex.shi@intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com, jeremy@goop.org,
        seto.hidetoshi@jp.fujitsu.com, borislav.petkov@amd.com,
        tony.luck@intel.com, luto@mit.edu, riel@redhat.com, avi@redhat.com,
        len.brown@intel.com, tj@kernel.org, akpm@linux-foundation.org,
        cl@gentwo.org, jbeulich@suse.com, eric.dumazet@gmail.com,
        akinobu.mita@gmail.com, cpw@sgi.com, penberg@kernel.org,
        steiner@sgi.com, viro@zeniv.linux.org.uk,
        kamezawa.hiroyu@jp.fujitsu.com, aarcange@redhat.com,
        rientjes@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 8/8] x86/tlb: do flush_tlb_kernel_range by 'invlpg'
Message-ID: <20120613145656.GB32604@tassilo.jf.intel.com>
References: <1339492005-20241-1-git-send-email-alex.shi@intel.com>
 <1339492005-20241-9-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339492005-20241-9-git-send-email-alex.shi@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 05:06:45PM +0800, Alex Shi wrote:
> This patch do flush_tlb_kernel_range by 'invlpg'. The performance pay
> and gain was analyzed in my patch (x86/flush_tlb: try flush_tlb_single
> one by one in flush_tlb_range). Now we move this logical into kernel
> part. The pay is multiple 'invlpg' execution cost, that is same. but
>  the gain(cost reducing of TLB entries refilling) is absoulutely
> increased.

The subtle point is whether INVLPG flushes global pages or not.
After some digging I found a sentence in the SDM that says it does.
So it may be safe.

What does it improve?

-Andi
