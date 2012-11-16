Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab2KPV3Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 16:29:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:4069 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753520Ab2KPV3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 16:29:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,266,1352102400"; 
   d="scan'208";a="220828243"
Message-ID: <50A6B01F.3000708@linux.intel.com>
Date: Fri, 16 Nov 2012 13:29:03 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v5 11/11] thp, vmstat: implement HZP_ALLOC and HZP_ALLOC_FAILED
 events
References: <1352300463-12627-1-git-send-email-kirill.shutemov@linux.intel.com> <1352300463-12627-12-git-send-email-kirill.shutemov@linux.intel.com> <alpine.DEB.2.00.1211141541000.22537@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1211141541000.22537@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2012 03:41 PM, David Rientjes wrote:
> 
> Nobody is going to know what hzp_ is, sorry.  It's better to be more 
> verbose and name them what they actually are: THP_ZERO_PAGE_ALLOC and 
> THP_ZERO_PAGE_ALLOC_FAILED.  But this would assume we want to lazily 
> allocate them, which I disagree with hpa about.
> 

You want to permanently sit on 2 MiB of memory on all systems?  That
being an obvious nonstarter, then you end up having to make some kind of
static control, with all the problems that entails (if Linus had not set
his foot down on tunables a long time ago, we today would have had a
Linux mm which only performed well if you manually set hundreds or
thousands of parameters) you either have lazy allocation or you go with
the virtual huge zero page solution and just accept that either is going
to perform poorly under some set of pathological circumstances.

	-hpa

