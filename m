Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab2H0K1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 06:27:55 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:34879 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab2H0K1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 06:27:52 -0400
Date: Mon, 27 Aug 2012 12:27:42 +0200
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org,
        ak@linux.intel.com, hughd@google.com, linux-kernel@vger.kernel.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Subject: Re: [RFC patch 2/7] thp: introduce pmdp_invalidate()
Message-ID: <20120827122742.1281aba4@thinkpad>
In-Reply-To: <CAJd=RBBQJCxgdrEnAdoVu+PLjkzTOBnDyJX_bqUdbQdo5TQoJw@mail.gmail.com>
References: <20120823171733.595087166@de.ibm.com>
	<20120823171854.473831303@de.ibm.com>
	<CAJd=RBBQJCxgdrEnAdoVu+PLjkzTOBnDyJX_bqUdbQdo5TQoJw@mail.gmail.com>
Reply-To: gerald.schaefer@de.ibm.com
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12082710-0542-0000-0000-000002D7C0C2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Aug 2012 20:36:37 +0800
Hillf Danton <dhillf@gmail.com> wrote:

> On Fri, Aug 24, 2012 at 1:17 AM, Gerald Schaefer
> <gerald.schaefer@de.ibm.com> wrote:
> 
> > +#ifndef __HAVE_ARCH_PMDP_INVALIDATE
> > +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > +static inline void pmdp_invalidate(struct vm_area_struct *vma,
> > +                                  unsigned long address, pmd_t *pmdp)
> > +{
> > +       set_pmd_at(vma->vm_mm, address, pmd, pmd_mknotpresent(*pmd));
> 
> 	set_pmd_at(vma->vm_mm, address, pmdp, pmd_mknotpresent(*pmdp));  yes?

Ah yes, I mixed that up, thanks.

