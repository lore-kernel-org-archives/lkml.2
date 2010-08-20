Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab0HTQfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 12:35:16 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:18830 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752942Ab0HTQfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 12:35:14 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Greg KH <gregkh@suse.de>, Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <1282321974.12544.24.camel@zakaz.uk.xensource.com>
References: <20100818203143.735033743@clark.site>
	 <1282308887.3170.5439.camel@zakaz.uk.xensource.com>
	 <AANLkTin7L=v1GR2=U-mvESyrP2vySYLRa4U-fh9-L38F@mail.gmail.com>
	 <AANLkTim1ABgiwscmaTZxeO9FxB4FacUNe0ahzUctQkn6@mail.gmail.com>
	 <1282321974.12544.24.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Aug 2010 17:35:01 +0100
Message-ID: <1282322101.12544.25.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [2/3] mm: fix up some user-visible effects of the stack guard
 page
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=DhNl2YeytwJssBBGe49HJX82LNDFEEVkpVB34RXKaPo= c=1 sm=0 a=isDwiucj6PoA:10 a=IkcTkHD0fZMA:10 a=D81oFJkc8IoVLJme2vkA:9 a=Q1nS95oSogborT46ncdgxXKyXDAA:4 a=QEXdDO2ut3YA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-20 at 17:32 +0100, Ian Campbell wrote:

> On Fri, 2010-08-20 at 09:07 -0700, Linus Torvalds wrote:
> 
> > Actually, thinking some more about it, that may not be a good idea.
> > Why? Simply because we may want to merge the vma's back together if
> > you do munlock. And it won't (and mustn't) merge if the vm_flags
> > differ in VM_GROWSDOWN.
> > 
> > So I do think we want to keep VM_GROWSDOWN (and VM_GROWSUP on
> PA-RISC)
> > even across a vma split.
> 
> I naively hacked something together and it did seem to work, but I
> shared your worries about merging.
> 
> > Of course, we could set a flag whether the vma really does have a
> > guard page or not.
> 
> Bits in vma->vm_flags seems to be in rather short supply :-( 

On the other hand the VMA merging is just an optimisation, isn't it?

-- 
Ian Campbell

Many people are desperately looking for some wise advice which will
recommend that they do what they want to do.

