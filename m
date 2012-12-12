Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab2LLVsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 16:48:10 -0500
Received: from mga11.intel.com ([192.55.52.93]:31180 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755168Ab2LLVsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 16:48:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,269,1355126400"; 
   d="scan'208";a="263186475"
Message-ID: <50C8FB94.6050209@linux.intel.com>
Date: Wed, 12 Dec 2012 13:48:04 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v5 09/11] thp: lazy huge zero page allocation
References: <1352300463-12627-1-git-send-email-kirill.shutemov@linux.intel.com> <1352300463-12627-10-git-send-email-kirill.shutemov@linux.intel.com> <alpine.DEB.2.00.1211141535190.22537@chino.kir.corp.google.com> <20121115094155.GG9676@otc-wbsnb-06> <20121212133051.6dad3722.akpm@linux-foundation.org>
In-Reply-To: <20121212133051.6dad3722.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 01:30 PM, Andrew Morton wrote:
>>
>> I can rewrite the check to static_key if you want. Would it be better?
> 
> The new test-n-branch only happens on the first read fault against a
> thp huge page, yes?  In which case it's a quite infrequent event and I
> suspect this isn't worth bothering about.
> 

Not to mention that flipping the static key is *incredibly* expensive.

	-hpa


