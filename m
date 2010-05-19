Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983Ab0ESLvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 07:51:11 -0400
Received: from mga10.intel.com ([192.55.52.92]:5575 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757959Ab0ESLvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 07:51:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,263,1272870000"; 
   d="scan'208";a="568599383"
Message-ID: <4BF3D0A8.9050509@linux.intel.com>
Date: Wed, 19 May 2010 19:51:04 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: "ak@linux.intel.com" <ak@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "dnelson@redhat.com" <dnelson@redhat.com>,
       Andi Kleen <andi@firstfloor.org>,
       "Li, Haicheng" <haicheng.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX] [PATCH v2] x86: update all PGDs for direct mapping	changes
 on 64bit.
References: <4BCD1F46.2060002@linux.intel.com> <20100420051759.GA15370@localhost>
In-Reply-To: <20100420051759.GA15370@localhost>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm sorry for my slow response ...

Wu Fengguang wrote:
 >> +static void sync_global_pgds(unsigned long start, unsigned long end)
 >
 > It seems that this function can reuse code with vmalloc_sync_all().

agreed.

 > __init_extra_mapping() is not related to memory hotplug (note: the
 > __init prefix), so not necessary to change this function?

yes, I think you are right. We don't need to change __init_extra_mapping().

 >>   vmemmap_populate(struct page *start_page, unsigned long size, int node)
 > It's not necessary to introduce the "start" and "err" variables.
 > It helps simplify the patch (or you can put them to another cleanup
 > only patch).

ok, let's make the fix as simple as possible.

I'll send out the revised version right now. Thank you for the review.

-haicheng
