Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab0LVQ2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 11:28:24 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:1477 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501Ab0LVQ2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 11:28:23 -0500
X-IronPort-AV: E=Sophos;i="4.60,214,1291611600"; 
   d="scan'208";a="128057067"
Subject: Re: [Xen-devel] Re: [PATCH 04/10] xen/mmu: For 1-1 mapping,
 automatically set _PAGE_IOMAP.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@novell.com>, "hpa@zytor.com" <hpa@zytor.com>
In-Reply-To: <20101222150258.GD1760@dumpdata.com>
References: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
	 <1292967460-15709-5-git-send-email-konrad.wilk@oracle.com>
	 <4D112A4B.5000503@goop.org>  <20101222150258.GD1760@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Wed, 22 Dec 2010 16:27:24 +0000
Message-ID: <1293035244.4500.3744.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-22 at 15:02 +0000, Konrad Rzeszutek Wilk wrote:
> On Tue, Dec 21, 2010 at 02:29:31PM -0800, Jeremy Fitzhardinge wrote:
> > On 12/21/2010 01:37 PM, Konrad Rzeszutek Wilk wrote:
> > > @@ -832,6 +832,9 @@ static pteval_t pte_pfn_to_mfn(pteval_t val)
> > >  		pteval_t flags = val & PTE_FLAGS_MASK;
> > >  		unsigned long mfn = pfn_to_mfn(pfn);
> > >  
> > > +		if (mfn == pfn)
> > > +			flags |= _PAGE_IOMAP;
> > 
> > Why?  Does it really make sense to set _PAGE_IOMAP if they just happen
> > to be the same value?
> 
> Yes. Without this, user applications, such as 'dmidecode' cannot get
> data.

I think Jeremy's point is that the "mfn == pfn" here has false
positives, since it is possible that a normal RAM page has identical mfn
and pfn by pure chance.

Ian.


