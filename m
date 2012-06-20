Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab2FTNvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 09:51:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120Ab2FTNvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 09:51:48 -0400
Date: Wed, 20 Jun 2012 15:49:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] uprobes: write_opcode: alloc the new page outside
	of "retry" loop
Message-ID: <20120620134911.GB11582@redhat.com>
References: <20120619194636.GA30137@redhat.com> <20120619194759.GE30146@redhat.com> <20120620122939.GA4018@bandura.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120620122939.GA4018@bandura.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20, Anton Arapov wrote:
>
> On Tue, Jun 19, 2012 at 09:47:59PM +0200, Oleg Nesterov wrote:
> > @@ -214,19 +214,18 @@ static int write_opcode(struct arch_uprobe *auprobe, struct mm_struct *mm,
> >  	struct vm_area_struct *vma;
> >  	int ret;
> >
> > -retry:
> > -	/* Read the page with vaddr into memory */
> > -	ret = get_user_pages(NULL, mm, vaddr, 1, 0, 0, &old_page, &vma);
> > -	if (ret <= 0)
> > -		return ret;
> > -
> > -	ret = -ENOMEM;
> >  	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, vaddr);
>   Should we want NULL instead of vma in alloc_page_vma()? Or
> initialize vma with NULL...

OOPS. Thanks Anton, this should be fixed.

Oleg.

