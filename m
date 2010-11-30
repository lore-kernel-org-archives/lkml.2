Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab0K3SAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 13:00:52 -0500
Received: from mga14.intel.com ([143.182.124.37]:36320 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043Ab0K3SAu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 13:00:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,281,1288594800"; 
   d="scan'208";a="355086566"
From: "Luck, Tony" <tony.luck@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Huang, Ying" <ying.huang@intel.com>
CC: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Date: Tue, 30 Nov 2010 10:00:47 -0800
Subject: RE: [PATCH -v2 2/3] ACPI, APEI, Add APEI generic error status print
 support
Thread-Topic: [PATCH -v2 2/3] ACPI, APEI, Add APEI generic error status
 print support
Thread-Index: AcuQO1TWaGXJqlS/R26i7YDiOKoC1AAfGwGQ
Message-ID: <987664A83D2D224EAE907B061CE93D530191E8BCF1@orsmsx505.amr.corp.intel.com>
References: <1291085501-31494-1-git-send-email-ying.huang@intel.com>
	<1291085501-31494-3-git-send-email-ying.huang@intel.com>
 <20101129190343.7d7cea12.akpm@linux-foundation.org>
In-Reply-To: <20101129190343.7d7cea12.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	for (i = 0; i < strs_size; i++) {
> +		if (!(bits & (1U << i)))
> +			continue;
> +		str = strs[i];
> +		if (len && len + strlen(str) + 2 > 80) {
> +			printk("\n");
> +			len = 0;
> +		}
> +		if (!len)
> +			len = pr_pfx(pfx, "%s", str);
> +		else
> +			len += printk(", %s", str);
> +	}
> +	if (len)
> +		printk("\n");

Does printk() offer any guarantees about getting all the characters
from a single printk() call out to the console without interleaving
with messages from printk() calls on other cpus?  If it does, then
it would be a good idea to sprintf() the parts of this message to
a buffer and then use one printk() call.  I think I read that netconsole
ends up with one packet on the wire for each call to printk().

Trying to parse output jumbled together from multiple cpus
doesn't sound like fun.

-Tony
