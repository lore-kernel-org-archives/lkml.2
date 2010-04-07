Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab0DGGD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 02:03:59 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36254 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab0DGGDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 02:03:54 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: Arch specific mmap attributes (Was: mprotect pgprot handling weirdness)
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
In-Reply-To: <1270592111.13812.88.camel@pasglop>
References: <20100406185246.7E63.A69D9226@jp.fujitsu.com> <1270592111.13812.88.camel@pasglop>
Message-Id: <20100407095145.FB70.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  7 Apr 2010 15:03:45 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2010-04-06 at 19:26 +0900, KOSAKI Motohiro wrote:
> > > Ok, I see. No biggie. The main deal remains how we want to do that
> > > inside the kernel :-) I think the less horrible options here are
> > > to either extend vm_flags to always be 64-bit, or add a separate
> > > vm_map_attributes flag, and add the necessary bits and pieces to
> > > prevent merge accross different attribute vma's.
> > 
> > vma->vm_flags already have VM_SAO. Why do we need more flags?
> > At least, I dislike to add separate flags member into vma.
> > It might introduce unnecessary messy into vma merge thing.
> 
> Well, we did shove SAO in there, and used up the very last vm_flag for
> it a while back. Now I need another one, for little endian mappings. So
> I'm stuck.
> 
> But the problem goes further I believe. Archs do nowadays have quite an
> interesting set of MMU attributes that it would be useful to expose to
> some extent.

Generally speaking, It seems no good idea. desktop and server world don't
interest arch specific mmu attribute crap. because many many opensource
and ISV library don't care it. I know highend hpc and embedded have 
differenct eco-system. they might want to use such strange mmu feature.
I recommend to you are focusing popwerpc eco-system. 

I'm not against changing kernel internal. I only disagree mmu attribute
fashion will be become used widely.


> 
> Some powerpc's also provide storage keys for example and I think ARM
> have something along those lines. There's interesting cachability
> attributes too, on x86 as well. Being able to use such attributes to
> request for example a relaxed ordering mapping on x86 might be useful.
> 
> I think it basically boils down to either extend vm_flags to always be
> 64-bit, which seems to be Nick preferred approach, or introduct a
> vm_attributes with all the necessary changes to the merge code to take
> it into account (not -that- hard tho, there's only half a page of
> results in grep for these things :-)




