Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab2I2Ohw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 10:37:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755241Ab2I2Ohv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 10:37:51 -0400
Date: Sat, 29 Sep 2012 16:37:37 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 0/3] Virtual huge zero page
Message-ID: <20120929143737.GF26989@redhat.com>
References: <1348875441-19561-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20120929134811.GC26989@redhat.com>
 <20120929143006.GC4110@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120929143006.GC4110@tassilo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2012 at 07:30:06AM -0700, Andi Kleen wrote:
> On Sat, Sep 29, 2012 at 03:48:11PM +0200, Andrea Arcangeli wrote:
> > On Sat, Sep 29, 2012 at 02:37:18AM +0300, Kirill A. Shutemov wrote:
> > > Cons:
> > >  - increases TLB pressure;
> > 
> > I generally don't like using 4k tlb entries ever. This only has the
> 
> From theory I would also prefer the 2MB huge page.
> 
> But some numbers comparing between the two alternatives are definitely
> interesting.  Numbers are often better than theory.

Sure good idea, just all standard benchmarks likely aren't using zero
pages so I suggest a basic micro benchmark:

   some loop of() {
      memcmp(uninitalized_pointer, (char *)uninitialized_pointer+4G, 4G)
      barrier();
   }

> 
> > There would be a small cache benefit here... but even then some first
> > level caches are virtually indexed IIRC (always physically tagged to
> 
> Modern x86 doesn't have virtually indexed caches.

With the above memcmp, I'm quite sure the previous patch will beat the
new one by a wide margin, especially on modern x86 with more 2M TLB
entries and >= 8MB L2 caches.

But I agree we need to verify it before taking a decision, and that
the numbers are better than theory, or to rephrase it "let's check the
theory is right" :)
