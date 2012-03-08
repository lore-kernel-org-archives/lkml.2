Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab2CHVEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 16:04:49 -0500
Received: from merlin.infradead.org ([205.233.59.134]:58438 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab2CHVEq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 16:04:46 -0500
Message-ID: <1331240674.11248.427.camel@twins>
Subject: Re: [PATCH v2] x86,nmi: Fix page faults by nmiaction if kmemcheck
 is enabled
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>
Date: Thu, 08 Mar 2012 22:04:34 +0100
In-Reply-To: <1331240549-13120-1-git-send-email-dzickus@redhat.com>
References: <1331240549-13120-1-git-send-email-dzickus@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-08 at 16:02 -0500, Don Zickus wrote:
> From: Li Zhong <zhong@linux.vnet.ibm.com>
> 
> This patch tries to fix the problem of page fault exception caused by
> accessing nmiaction structure in nmi if kmemcheck is enabled.
> 
> If kmemcheck is enabled, the memory allocated through slab are in pages
> that are marked non-present, so that some checks could be done in the
> page fault handling code ( e.g. whether the memory is read before
> written to ).
> As nmiaction is allocated in this way, so it resides in a non-present
> page. Then there is a page fault while the nmi code accessing the
> nmiaction structure, which would then cause a warning by
> WARN_ON_ONCE(in_nmi()) in kmemcheck_fault(), called by do_page_fault().
> 
> v2: as Peter suggested, changed the nmiaction to use static storage.
> 
> v3: as Peter suggested, use macro to shorten the codes. Also keep the
> original usage of register_nmi_handler, so users of this call doesn't
> need change.
> 
> [simplified wrappers -dcz]
> 
> Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
> Signed-off-by: Don Zickus <dzickus@redhat.com> 

Thanks!

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
