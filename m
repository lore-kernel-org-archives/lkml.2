Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab2JLWgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 18:36:50 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:20621 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab2JLWgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 18:36:49 -0400
Date: Fri, 12 Oct 2012 15:36:41 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH V2 3/7]: PVH:  mmu related changes.
Message-ID: <20121012153641.2b915219@mantra.us.oracle.com>
In-Reply-To: <1350032276.14806.53.camel@zakaz.uk.xensource.com>
References: <20121011145817.0d744c99@mantra.us.oracle.com>
	<1350032276.14806.53.camel@zakaz.uk.xensource.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2012 09:57:56 +0100
Ian Campbell <Ian.Campbell@citrix.com> wrote:

> On Thu, 2012-10-11 at 22:58 +0100, Mukesh Rathor wrote:
> > @@ -2177,8 +2210,19 @@ static const struct pv_mmu_ops xen_mmu_ops
> > __initconst = {
> > 
> >  void __init xen_init_mmu_ops(void)
> >  {
> > -       x86_init.mapping.pagetable_reserve =
> > xen_mapping_pagetable_reserve; x86_init.paging.pagetable_init =
> > xen_pagetable_init; +
> > +       if (xen_feature(XENFEAT_auto_translated_physmap)) {
> > +               pv_mmu_ops.flush_tlb_others = xen_flush_tlb_others;
> > +
> > +               /* For PCI devices to map iomem. */
> > +               if (xen_initial_domain()) {
> > +                       pv_mmu_ops.set_pte = native_set_pte;
> > +                       pv_mmu_ops.set_pte_at = native_set_pte_at;
> 
> What do these end up being for the !xen_initial_domain case? I'd have
> expected native_FOO.

Yeah, right, we kept on changing the functions that they were set
to, until it came down to just native_*. I just didn't think it didnt
being set. Too much too fast... ok, time to slow down... :) :)..

thanks
Mukesh

