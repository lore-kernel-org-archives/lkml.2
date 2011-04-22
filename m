Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab1DVVdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 17:33:14 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56469 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756572Ab1DVVdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 17:33:11 -0400
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to
 expand_upwards
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@linux.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
        Tejun Heo <tj@kernel.org>, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <1303411537.9048.3583.camel@nimitz>
References: <1303337718.2587.51.camel@mulgrave.site>
	 <alpine.DEB.2.00.1104201530430.13948@chino.kir.corp.google.com>
	 <20110421221712.9184.A69D9226@jp.fujitsu.com>
	 <1303403847.4025.11.camel@mulgrave.site>
	 <alpine.DEB.2.00.1104211328000.5741@router.home>
	 <1303411537.9048.3583.camel@nimitz>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Apr 2011 16:33:05 -0500
Message-ID: <1303507985.2590.47.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 11:45 -0700, Dave Hansen wrote:
> On Thu, 2011-04-21 at 13:33 -0500, Christoph Lameter wrote:
> > http://www.linux-mips.org/archives/linux-mips/2008-08/msg00154.html
> > 

By the way, this reference is actively wrong for parisc (having just
debugged the problem).  The basic issue is that until we start paging,
we have the kernel and some memory beyond it barely covered with the pg0
page table set up in head.S  On our systems, that extends out to 16MB.
SPARSEMEM is much more bootmem resource greedy than DISCONTIGMEM, so if
we actually call sparse_init() before we have the page tables set up, we
fall off the end of our 16MB mapping and go boom.  For us, therefore, we
can't call sparse_init() until we have our proper page tables in place.

James


