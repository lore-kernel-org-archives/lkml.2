Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab2JAPeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 11:34:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:49149 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641Ab2JAPe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 11:34:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,517,1344236400"; 
   d="scan'208";a="228623224"
Message-ID: <5069B804.6040902@linux.intel.com>
Date: Mon, 01 Oct 2012 08:34:28 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 0/3] Virtual huge zero page
References: <1348875441-19561-1-git-send-email-kirill.shutemov@linux.intel.com> <20120929134811.GC26989@redhat.com>
In-Reply-To: <20120929134811.GC26989@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2012 06:48 AM, Andrea Arcangeli wrote:
> 
> There would be a small cache benefit here... but even then some first
> level caches are virtually indexed IIRC (always physically tagged to
> avoid the software to notice) and virtually indexed ones won't get any
> benefit.
> 

Not quite.  The virtual indexing is limited to a few bits (e.g. three
bits on K8); the right way to deal with that is to color the zeropage,
both the regular one and the virtual one (the virtual one would circle
through all the colors repeatedly.)

The cache difference, therefore, is *huge*.

> I guess it won't make a whole lot of difference but my preference is
> for the previous implementation that always guaranteed huge TLB
> entries whenever possible. Said that I'm fine either ways so if
> somebody has strong reasons for wanting this one, I'd like to hear
> about it.

It's a performance tradeoff, and it can, and should, be measured.

	-hpa

