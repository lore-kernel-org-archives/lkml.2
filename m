Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161285Ab2KOA3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 19:29:09 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:37536 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161112Ab2KOA3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 19:29:08 -0500
Date: Wed, 14 Nov 2012 16:29:06 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v5 00/11] Introduce huge zero page
In-Reply-To: <20121114133342.cc7bcd6e.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1211141626220.482@chino.kir.corp.google.com>
References: <1352300463-12627-1-git-send-email-kirill.shutemov@linux.intel.com> <20121114133342.cc7bcd6e.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012, Andrew Morton wrote:

> For this reason and for general ease-of-testing: can and should we add
> a knob which will enable users to disable the feature at runtime?  That
> way if it causes problems or if we suspect it's causing problems, we
> can easily verify the theory and offer users a temporary fix.
> 

I think it would be best to add a tunable under 
/sys/kernel/mm/transparent_hugepage and enable it by default whenever 
/sys/kernel/mm/transparent_hugepage/enabled is "always" or "madvise" and 
allocate the huge zero page under such circumstances.  Then we can free it 
if disabled (or if enabled is set to "never") and avoid all the 
refcounting and lazy allocation that causes a regression on Kirill's 
benchmark.
