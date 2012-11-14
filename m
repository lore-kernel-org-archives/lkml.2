Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992475Ab2KNXhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 18:37:13 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:64301 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992449Ab2KNXhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 18:37:11 -0500
Date: Wed, 14 Nov 2012 15:37:09 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v5 09/11] thp: lazy huge zero page allocation
In-Reply-To: <1352300463-12627-10-git-send-email-kirill.shutemov@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1211141535190.22537@chino.kir.corp.google.com>
References: <1352300463-12627-1-git-send-email-kirill.shutemov@linux.intel.com> <1352300463-12627-10-git-send-email-kirill.shutemov@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2012, Kirill A. Shutemov wrote:

> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> 
> Instead of allocating huge zero page on hugepage_init() we can postpone it
> until first huge zero page map. It saves memory if THP is not in use.
> 

Is it worth the branch on every non-write pagefault after that?  The 
unlikely() is not going to help on x86.  If thp is enabled in your 
.config (which isn't the default), then I think it's better to just 
allocate the zero huge page once and avoid any branches after that to 
lazily allocate it.  (Or do it only when thp is set to "madvise" or 
"always" if booting with transparent_hugepage=never.)
