Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946003Ab2KNXcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 18:32:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38583 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945916Ab2KNXcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 18:32:45 -0500
Date: Wed, 14 Nov 2012 15:32:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v5 00/11] Introduce huge zero page
Message-Id: <20121114153243.0f6d6bec.akpm@linux-foundation.org>
In-Reply-To: <20121114232013.7ee42414@pyramind.ukuu.org.uk>
References: <1352300463-12627-1-git-send-email-kirill.shutemov@linux.intel.com>
	<20121114133342.cc7bcd6e.akpm@linux-foundation.org>
	<20121114232013.7ee42414@pyramind.ukuu.org.uk>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012 23:20:13 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > I'm still a bit concerned over the possibility that some workloads will
> > cause a high-frequency free/alloc/memset cycle on that huge zero page. 
> > We'll see how it goes...
> 
> That is easy enough to fix - we can delay the freeing by a random time or
> until memory pressure is applied.
> 

The current code does the latter, by freeing the page via a
"slab"-shrinker callback.

But I do suspect that with the right combination of use/unuse and
memory pressure, we could still get into the high-frequency scenario.

