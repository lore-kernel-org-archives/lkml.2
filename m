Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab1IVVUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 17:20:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:20374 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914Ab1IVVUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 17:20:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,425,1312182000"; 
   d="scan'208";a="53958721"
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        mingo@elte.hu, dsahern@gmail.com, robert.richter@amd.com
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v5)
References: <20110922123128.GA9761@quad>
Date: Thu, 22 Sep 2011 14:20:43 -0700
In-Reply-To: <20110922123128.GA9761@quad> (Stephane Eranian's message of "Thu,
	22 Sep 2011 14:31:28 +0200")
Message-ID: <m2pqisjmtw.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane Eranian <eranian@google.com> writes:

> The goal of this patch is to include more information
> about the host environment into the perf.data so it is
> more self-descriptive. Overtime, profiles are captured
> on various machines and it becomes hard to track what
> was recorded, on what machine and when.

I read it near completely.

The only weird thing were the .byte coded push/pops 
in CPUID.

Also the /proc parser doesn't seem very robust, 
e.g. strstr is not a good way to check for a field.

And the code reading /proc lines with fgets should
likely use getline()

Then the bswap code would be much nicer inside a macro.

Other than that it looks good.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
