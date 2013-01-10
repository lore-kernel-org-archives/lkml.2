Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab3AJLnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 06:43:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413Ab3AJLnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 06:43:10 -0500
Date: Thu, 10 Jan 2013 12:42:54 +0100
From: Anton Arapov <anton@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [RFC PATCH v2 4/4] uretprobes: invoke return probe handlers
Message-ID: <20130110114254.GA12964@bandura.brq.redhat.com>
References: <1357730692-3928-1-git-send-email-anton@redhat.com>
 <1357730692-3928-5-git-send-email-anton@redhat.com>
 <20130109162842.GD27722@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130109162842.GD27722@redhat.com>
X-PGP-Key: http://people.redhat.com/aarapov/gpg
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 05:28:42PM +0100, Oleg Nesterov wrote:
> On 01/09, Anton Arapov wrote:
> >
> >  static void handle_swbp(struct pt_regs *regs)
> >  {
> >  	struct uprobe *uprobe;
> > +	struct xol_area *area;
> >  	unsigned long bp_vaddr;
> >  	int uninitialized_var(is_swbp);
> >  
> >  	bp_vaddr = uprobe_get_swbp_addr(regs);
> > -	uprobe = find_active_uprobe(bp_vaddr, &is_swbp);
> > +	area = get_xol_area();
> 
> No, we do not need to allocate xol area here.
> 
> > +	if (area) {
> > +		if (bp_vaddr == area->vaddr) {
> > +			handle_rp_swbp(regs);
> 
> Can't understand... this should check bp_vaddr == rp_trampoline_vaddr ?
> 
> Again, unless you remove rp_trampoline_vaddr altogether.

yeah, forgot to correct this chunk before I sent it here. I was working on
xol_get_trampoline_slot removal as you suggested.

thanks for valuable comments, seems you are okay with approach to add
rp_handler into uprobe_consumer struct.

Anton.
