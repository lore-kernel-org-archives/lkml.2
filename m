Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab1BJIcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 03:32:52 -0500
Received: from mga02.intel.com ([134.134.136.20]:20271 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab1BJIcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 03:32:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,451,1291622400"; 
   d="scan'208";a="601250652"
Subject: RE: [RFC 1/2] lib, Make gen_pool memory allocator lockless
From: Huang Ying <ying.huang@intel.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <987664A83D2D224EAE907B061CE93D53019D18D43A@orsmsx505.amr.corp.intel.com>
References: <1297236451-11331-1-git-send-email-ying.huang@intel.com>
	 <1297236451-11331-2-git-send-email-ying.huang@intel.com>
	 <987664A83D2D224EAE907B061CE93D53019D18D43A@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Feb 2011 16:32:35 +0800
Message-ID: <1297326755.32714.0.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-10 at 03:03 +0800, Luck, Tony wrote:
> +static int set_bits_ll(unsigned long *addr, unsigned long mask_to_set)
> +{
> +	unsigned long val, nval;
> +
> +	nval = *addr;
> +	do {
> +		val = nval;
> +		if (val & mask_to_set)
> +			return -EBUSY;
> +	} while ((nval = cmpxchg(addr, val, val | mask_to_set)) != val);
> +
> +	return 0;
> +}
> 
> Spin loops like this should have a call to cpu_relax(), shouldn't they?

Thanks!  Sounds reasonable to me.  Will change it.

Best Regards,
Huang Ying


