Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab1IBHWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 03:22:38 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:53604 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab1IBHWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 03:22:37 -0400
X-IronPort-AV: E=Sophos;i="4.68,317,1312156800"; 
   d="scan'208";a="7565448"
Subject: Re: [Xen-devel] Re: [Revert] Re: [PATCH] mm: sync vmalloc address
 space page tables in alloc_vm_area()
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        David Vrabel <david.vrabel@citrix.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <4E5FED1A.1000300@goop.org>
References: <1314877863-21977-1-git-send-email-david.vrabel@citrix.com>
	 <20110901161134.GA8979@dumpdata.com>  <4E5FED1A.1000300@goop.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Fri, 2 Sep 2011 08:22:34 +0100
Message-ID: <1314948154.28989.158.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-01 at 21:37 +0100, Jeremy Fitzhardinge wrote:
> On 09/01/2011 09:11 AM, Konrad Rzeszutek Wilk wrote:
> > On Thu, Sep 01, 2011 at 12:51:03PM +0100, David Vrabel wrote:
> >> From: David Vrabel <david.vrabel@citrix.com>
> > Andrew,
> >
> > I was wondering if you would be Ok with this patch for 3.1.
> >
> > It is a revert (I can prepare a proper revert if you would like
> > that instead of this patch).
> >
> > The users of this particular function (alloc_vm_area) are just
> > Xen. There are no others.
> 
> I'd prefer to put explicit vmalloc_sync_all()s in the callsites where
> necessary, and ultimately try to work out ways of avoiding it altogether
> (like have some hypercall wrapper which touches the arg memory to make
> sure its mapped?).

That only syncs the current pagetable though. If that is sufficient (and
it could well be) then perhaps just doing a vmalloc_sync_one on the
current page tables directly would be better than faulting to do it?

It's the sort of thing you could hide inside the gnttab_set_map_op type
helpers I guess?

Ian.


