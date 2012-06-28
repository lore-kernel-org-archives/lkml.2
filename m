Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab2F1QAx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 12:00:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293Ab2F1QAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 12:00:51 -0400
Date: Thu, 28 Jun 2012 17:00:46 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Don Morris <don.morris@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 05/40] autonuma: define _PAGE_NUMA_PTE and _PAGE_NUMA_PMD
Message-ID: <20120628150046.GA6676@redhat.com>
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com>
 <1340888180-15355-6-git-send-email-aarcange@redhat.com>
 <4FEC7487.9020909@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FEC7487.9020909@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Don,

On Thu, Jun 28, 2012 at 08:13:11AM -0700, Don Morris wrote:
> On 06/28/2012 05:55 AM, Andrea Arcangeli wrote:
> > We will set these bitflags only when the pmd and pte is non present.
> > 
> 
> Just a couple grammar nitpicks.
> 
> > They work like PROT_NONE but they identify a request for the numa
> > hinting page fault to trigger.
> > 
> > Because we want to be able to set these bitflag in any established pte
> 
> these bitflags
> 
> > or pmd (while clearing the present bit at the same time) without
> > losing information, these bitflags must never be set when the pte and
> > pmd are present.
> > 
> > For _PAGE_NUMA_PTE the pte bitflag used is _PAGE_PSE, which cannot be
> > set on ptes and it also fits in between _PAGE_FILE and _PAGE_PROTNONE
> > which avoids having to alter the swp entries format.
> > 
> > For _PAGE_NUMA_PMD, we use a reserved bitflag. pmds never contain
> > swap_entries but if in the future we'll swap transparent hugepages, we
> > must keep in mind not to use the _PAGE_UNUSED2 bitflag in the swap
> > entry format and to start the swap entry offset above it.
> > 
> > PAGE_UNUSED2 is used by Xen but only on ptes established by ioremap,
> > but it's never used on pmds so there's no risk of collision with Xen.
> 
> Maybe "but only on ptes established by ioremap, never on pmds so
> there's no risk of collision with Xen." ? The extra "but" just
> doesn't flow in the original.

Agreed and applied, thanks!
Andrea
