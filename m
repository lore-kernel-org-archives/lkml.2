Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab0H0Ojw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 10:39:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:22667 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab0H0Oju (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 27 Aug 2010 10:39:50 -0400
Date: Fri, 27 Aug 2010 10:38:44 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: hpa@zytor.com, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 01/10] x86/iommu: Add IOMMU_INIT macros, .iommu_table
 section, and iommu_table_entry structure.
Message-ID: <20100827143844.GA32547@phenom.dumpdata.com>
References: <1282845485-8991-1-git-send-email-konrad.wilk@oracle.com>
 <1282845485-8991-2-git-send-email-konrad.wilk@oracle.com>
 <20100826181913.GA5947@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100826181913.GA5947@merkur.ravnborg.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 08:19:13PM +0200, Sam Ravnborg wrote:
> > diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
> > index d0bb522..b92e040 100644
> > --- a/arch/x86/kernel/vmlinux.lds.S
> > +++ b/arch/x86/kernel/vmlinux.lds.S
> > @@ -260,6 +260,13 @@ SECTIONS
> >  		*(.altinstr_replacement)
> >  	}
> >  
> > +	.iommu_table : AT(ADDR(.iommu_table) - LOAD_OFFSET) {
> > +		__iommu_table = .;
> > +		*(.iommu_table)
> > +		. = ALIGN(8);
> > +		__iommu_table_end = .;
> > +	}
> > +
> 
> So we have yet another magic section in vmlinux.lds.S
> A nice comemnt that expalins what this is used for and why
> it is discardable etc. would be nice.
> 
> Lots of magic sections in same file miss this,
> but thats not an example to follwow.

Sure. Will provide one and also explain the other sections that I am
familiar with.

Thanks for your feedback!
