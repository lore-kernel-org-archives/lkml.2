Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631Ab1FOPDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 11:03:20 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:43426 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755233Ab1FOPDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 11:03:16 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: R0CUHrcVM1nCS8YG4ehe.T4SCOqzME3qzf2EGRbRlbTH45m
 fGsWxGQIBhrHHKvy5p5y.dJCrtTuNNAYFPXk2C3F7EjEqbr54SpoLHZ4ku22
 OUi3KKjtfpqid8l.8wpeODl8ZWXTIEvTJ1A_LCvRaKnp2K5G62D.JwAxC29c
 EtQzPqcur4sTdeBCmV1mIEFiR8uO0VHruxdOk1j38SjOEGZ9QqjmhpGNmOgJ
 g7g8IX8gXUfMBV7XXylyx1gyfvAQCWHyg4gYC9a.gBr8s09K_3I_b8MfqIGz
 dcwGoXYk_CRZMR_Foc4DlWKJkR6c4ppoxtjJ9XONrtGl3Qa5X
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 15 Jun 2011 10:03:14 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Rik van Riel <riel@redhat.com>
cc: Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kyle McMartin <kyle@redhat.com>
Subject: Re: SLUB BUG: check_slab called with interrupts enabled
In-Reply-To: <4DF8C80F.7090403@redhat.com>
Message-ID: <alpine.DEB.2.00.1106150959500.768@router.home>
References: <4DF8C80F.7090403@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jun 2011, Rik van Riel wrote:

> Hi Christoph,
>
> last night I got an interesting backtrace running 3.0-rc3
> (Fedora Rawhide kernel package).  Unfortunately netconsole
> seems to be incompatible with KVM at the moment, so I had
> to capture the oops on my digital camera and will be
> transcribing just the backtrace.
>
> Essentially, kernel 3.0-rc3 hit this bug:
>
> static int check_slab(struct kmem_cache *s, struct page *page)
> {
>         int maxobj;
>
>         VM_BUG_ON(!irqs_disabled());
>
> The call trace:
>
> check_slab
> alloc_debug_processing
> __slab_alloc
> kmem_cache_alloc
> bvec_alloc_bs
> bio_alloc_bioset
> bio_alloc
> mpage_alloc
> do_mpage_readpage
> ... followed by ext4 and VFS code, obviously innocent

__slab_alloc() disables interrupts so alloc_debug_processing() should not
run into this issue.

There are no additional special slub patches applied right? Because some
of the patches under discussion change the interrupt disable handling a
bit.

