Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613Ab1GTNLP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 09:11:15 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:44515 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab1GTNLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 09:11:14 -0400
Date: Wed, 20 Jul 2011 09:09:04 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Jackson <Ian.Jackson@eu.citrix.com>
Cc: stefano.stabellini@eu.citrix.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@elte.hu,
        hpa@linux.intel.com, yinghai@kernel.org
Subject: Re: [Xen-devel] [PATCH tip/x86/mm] x86_32: calculate additional
 memory needed by the fixmap
Message-ID: <20110720130904.GA19186@dumpdata.com>
References: <m2n.s.1Qimoi-131463@chiark.greenend.org.uk>
 <20004.24417.577289.167313@mariner.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20004.24417.577289.167313@mariner.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4E26D37E.0004:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 05:29:21PM +0100, Ian Jackson wrote:
> stefano.stabellini@eu.citrix.com writes ("[Xen-devel] [PATCH tip/x86/mm] x86_32: calculate additional memory needed by the fixmap"):
> > Unfortunately this code is rather complex and depends on the behaviour
> > of other functions but I hope to have covered all the corner cases.
> 
> I'm sorry to say that think this is really the wrong approach.
> I agree that *some* change needs to be made, as this is currently a
> serious regression in tip/x86/mm.

tip/x86/mm should boot with this patch, right?

> 
> But the correct change is in fact to undo the reversion of
>   "x86,xen: introduce x86_init.mapping.pagetable_reserve"
> That was a hook with a reasonable and defined interface.
> 
> What we are having instead, now, is a fragile piece of code that tries
> to second-guess the complex config- and hardware-dependent
> memory-allocation behaviour of the rest of the startup code.  This is
> a recipe for making things break.

Stefano did an excellent job at doing an archaeological excavation
and finding all the little pieces and bringing them up to surface
via this function. We have now the full accounting of the early
bootup code and its page table creation. And based on that we can
tighten the dance between pgt_end/pgt_begin/pgt_top to WARN much
sooner - and I hope make the code more simpler.

Sure there are some bugs that we won't find until more folks start
testing it - I've only found this one b/c of playing with a bigger
set of .config variants. But that is part of the 3.1-rcX cycle - to
find them and fix them. Or if we cannot fix them, then revert this
whole patchset and think then some more - maybe at the Linux Plumbers
Conference or the Linux Kernel mini-summits.
