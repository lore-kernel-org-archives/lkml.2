Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597Ab2EVBLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 21:11:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:55946 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700Ab2EVBKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 21:10:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="155431907"
Message-ID: <4FBAE71F.5000801@intel.com>
Date: Tue, 22 May 2012 09:08:47 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, cl@linux-foundation.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, mgorman@suse.de,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: unnecessary tlb flush in mprotect
References: <4FB9FD1D.6000001@intel.com>
In-Reply-To: <4FB9FD1D.6000001@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2012 04:30 PM, Alex Shi wrote:

> when mprotect just change prots of non-present pages, current mprotect
> still do the tlb flush in check_protection().
> but according to 4.10.2.3 Intel SDM V3A (
> www.intel.com/Assets/ja_JP/PDF/manual/253668.pdf ) at that time, TLB has
> no this lines for this page. So, tlb flush is just waste time. (for cr3
> rewrite, flush all tlb, or invlpg, like a 'nop' in intel cpu)
> 
> Do we need to add the pte_present similar check here to prevent the
> unnecessary tlb flushing? I mean, are there real case in word, User like
> to change page prots before assign a physical page to it?
> 


Any comments from linux-mm emailing list?

> 
> 
> Alex Shi


