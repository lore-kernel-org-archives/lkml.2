Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab2JJO3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 10:29:00 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:50585 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756464Ab2JJO25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 10:28:57 -0400
Date: Wed, 10 Oct 2012 10:17:08 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10] x86, mm: get early page table from BRK
Message-ID: <20121010141707.GH4005@phenom.dumpdata.com>
References: <1349757558-10856-1-git-send-email-yinghai@kernel.org>
 <1349757558-10856-4-git-send-email-yinghai@kernel.org>
 <20121009160133.GF7639@phenom.dumpdata.com>
 <CAE9FiQW8ubsQmtJk=bvZ5yGdBaBQSNWPpuACku+8sbb6_CG+rA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQW8ubsQmtJk=bvZ5yGdBaBQSNWPpuACku+8sbb6_CG+rA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 06:03:33PM -0700, Yinghai Lu wrote:
> On Tue, Oct 9, 2012 at 9:01 AM, Konrad Rzeszutek Wilk <konrad@kernel.org> wrote:
> >> +RESERVE_BRK(early_pgt_alloc, 16384);
> >
> > How did you come up with 16KB being the right size? What is this
> > based on? Can you provide a comment explaining why 16KB is the
> > right value on 32-bit and 64-bit machines?
> 
> good point, i add one line comment to the revised patch.
> 
> +/* need 3 4k for initial PMD_SIZE, 4k for 0-ISA_END_ADDRESS */

Can you explain the math please? It sounds like this is based on
the assumption that this you are using huge pages. But what if you
are not? What if you can only do 4KB pages?

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
