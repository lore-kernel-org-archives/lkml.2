Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935542Ab2JXUZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 16:25:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41602 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933652Ab2JXUZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 16:25:54 -0400
Date: Wed, 24 Oct 2012 13:25:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 10/10] thp: implement refcounting for huge zero page
Message-Id: <20121024132552.5f9a5f5b.akpm@linux-foundation.org>
In-Reply-To: <20121024194552.GA24460@otc-wbsnb-06>
References: <1350280859-18801-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1350280859-18801-11-git-send-email-kirill.shutemov@linux.intel.com>
	<20121018164502.b32791e7.akpm@linux-foundation.org>
	<20121018235941.GA32397@shutemov.name>
	<20121023063532.GA15870@shutemov.name>
	<20121022234349.27f33f62.akpm@linux-foundation.org>
	<20121023070018.GA18381@otc-wbsnb-06>
	<20121023155915.7d5ef9d1.akpm@linux-foundation.org>
	<20121023233801.GA21591@shutemov.name>
	<20121024122253.5ecea992.akpm@linux-foundation.org>
	<20121024194552.GA24460@otc-wbsnb-06>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2012 22:45:52 +0300
"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:

> On Wed, Oct 24, 2012 at 12:22:53PM -0700, Andrew Morton wrote:
> > 
> > I'm thinking that such a workload would be the above dd in parallel
> > with a small app which touches the huge page and then exits, then gets
> > executed again.  That "small app" sounds realistic to me.  Obviously
> > one could exercise the zero page's refcount at higher frequency with a
> > tight map/touch/unmap loop, but that sounds less realistic.  It's worth
> > trying that exercise as well though.
> > 
> > Or do something else.  But we should try to probe this code's
> > worst-case behaviour, get an understanding of its effects and then
> > decide whether any such workload is realisic enough to worry about.
> 
> Okay, I'll try few memory pressure scenarios.

Thanks.

> Meanwhile, could you take patches 01-09? Patch 09 implements simpler
> allocation scheme. It would be nice to get all other code tested.
> Or do you see any other blocker?

I think I would take them all, to get them tested while we're still
poking at the code.  It's a matter of getting my lazy ass onto reviewing
the patches.

The patches have a disturbing lack of reviewed-by's, acked-by's and
tested-by's on them.  Have any other of the MM lazy asses actually
spent some time with them yet?
