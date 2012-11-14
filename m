Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab2KNXl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 18:41:56 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64905 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409Ab2KNXlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 18:41:55 -0500
Date: Wed, 14 Nov 2012 15:41:53 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v5 11/11] thp, vmstat: implement HZP_ALLOC and HZP_ALLOC_FAILED
 events
In-Reply-To: <1352300463-12627-12-git-send-email-kirill.shutemov@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1211141541000.22537@chino.kir.corp.google.com>
References: <1352300463-12627-1-git-send-email-kirill.shutemov@linux.intel.com> <1352300463-12627-12-git-send-email-kirill.shutemov@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2012, Kirill A. Shutemov wrote:

> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> 
> hzp_alloc is incremented every time a huge zero page is successfully
> 	allocated. It includes allocations which where dropped due
> 	race with other allocation. Note, it doesn't count every map
> 	of the huge zero page, only its allocation.
> 
> hzp_alloc_failed is incremented if kernel fails to allocate huge zero
> 	page and falls back to using small pages.
> 

Nobody is going to know what hzp_ is, sorry.  It's better to be more 
verbose and name them what they actually are: THP_ZERO_PAGE_ALLOC and 
THP_ZERO_PAGE_ALLOC_FAILED.  But this would assume we want to lazily 
allocate them, which I disagree with hpa about.
