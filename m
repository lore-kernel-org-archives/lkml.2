Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049Ab1IAVSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 17:18:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44473 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757962Ab1IAVSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 17:18:39 -0400
Date: Thu, 1 Sep 2011 14:17:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: [Revert] Re: [PATCH] mm: sync vmalloc address space page tables
 in alloc_vm_area()
Message-Id: <20110901141754.76cef93b.akpm@linux-foundation.org>
In-Reply-To: <4E5FED1A.1000300@goop.org>
References: <1314877863-21977-1-git-send-email-david.vrabel@citrix.com>
	<20110901161134.GA8979@dumpdata.com>
	<4E5FED1A.1000300@goop.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Sep 2011 13:37:46 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> On 09/01/2011 09:11 AM, Konrad Rzeszutek Wilk wrote:
> > On Thu, Sep 01, 2011 at 12:51:03PM +0100, David Vrabel wrote:
> >> From: David Vrabel <david.vrabel@citrix.com>
> > Andrew,
> >
> > I was wondering if you would be Ok with this patch for 3.1.
> >
> > It is a revert (I can prepare a proper revert if you would like
> > that instead of this patch).

David's patch looks better than a straight reversion.

Problem is, I can't find David's original email anywhere.  Someone's
been playing games with To: headers?

> > The users of this particular function (alloc_vm_area) are just
> > Xen. There are no others.
> 
> I'd prefer to put explicit vmalloc_sync_all()s in the callsites where
> necessary,

What would that patch look like?  Bear in mind that we'll need something
suitable for 3.1 and for a 3.0 backport.

> and ultimately try to work out ways of avoiding it altogether
> (like have some hypercall wrapper which touches the arg memory to make
> sure its mapped?).

