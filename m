Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab2LLVa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 16:30:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55790 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab2LLVa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 16:30:58 -0500
Date: Wed, 12 Dec 2012 13:30:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v5 09/11] thp: lazy huge zero page allocation
Message-Id: <20121212133051.6dad3722.akpm@linux-foundation.org>
In-Reply-To: <20121115094155.GG9676@otc-wbsnb-06>
References: <1352300463-12627-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1352300463-12627-10-git-send-email-kirill.shutemov@linux.intel.com>
	<alpine.DEB.2.00.1211141535190.22537@chino.kir.corp.google.com>
	<20121115094155.GG9676@otc-wbsnb-06>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2012 11:41:55 +0200
"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:

> On Wed, Nov 14, 2012 at 03:37:09PM -0800, David Rientjes wrote:
> > On Wed, 7 Nov 2012, Kirill A. Shutemov wrote:
> > 
> > > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > > 
> > > Instead of allocating huge zero page on hugepage_init() we can postpone it
> > > until first huge zero page map. It saves memory if THP is not in use.
> > > 
> > 
> > Is it worth the branch on every non-write pagefault after that?  The 
> > unlikely() is not going to help on x86.  If thp is enabled in your 
> > .config (which isn't the default), then I think it's better to just 
> > allocate the zero huge page once and avoid any branches after that to 
> > lazily allocate it.  (Or do it only when thp is set to "madvise" or 
> > "always" if booting with transparent_hugepage=never.)
> 
> I can rewrite the check to static_key if you want. Would it be better?

The new test-n-branch only happens on the first read fault against a
thp huge page, yes?  In which case it's a quite infrequent event and I
suspect this isn't worth bothering about.


