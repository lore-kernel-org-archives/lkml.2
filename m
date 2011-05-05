Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab1EESp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 14:45:27 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:49686 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab1EESp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 14:45:26 -0400
Date: Thu, 5 May 2011 14:45:05 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>, hpa@linux.intel.com
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        yinghai@kernel.org, linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] Re: [PATCH] Two patches fixing regression introduced
 by 'x86-64, mm: Put early page table high' - does not work.
Message-ID: <20110505184505.GC10142@dumpdata.com>
References: <1304356942-17656-1-git-send-email-konrad.wilk@oracle.com>
 <4DBEEA69.7010000@zytor.com>
 <20110502180802.GA7498@dumpdata.com>
 <4DBEF8EC.7080301@zytor.com>
 <20110502193436.GA14666@dumpdata.com>
 <4DBF0D0C.8000105@zytor.com>
 <20110505162849.GA482@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110505162849.GA482@dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090204.4DC2F03F.0058:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 05, 2011 at 12:28:49PM -0400, Konrad Rzeszutek Wilk wrote:
> > >> OK, sounds like a plan then.  I like it because it doesn't affect the
> > >> native kernel.
> .. snip..
> 
> > First things first... are you pushing the workaround (you can add my
> > Acked-by:) or should I?
> 
> Grrr.. While it works on my machines, it does not work on some of the AMD opteron
> CPU machines. I asked Stefan Bader from Canonical to run a simple bootup test with
> 2.6.39-rc6 (Linus picked it already), and if it crashed, to use the 
> one that Stefano came up with.
> 
> And sure enough - it crashed and Stefano's fix worked. I've Stefano's
> patch in stable/bug-fixes-for-x86 and I am OK reverting the fix I came up.

To make it easier, I made a branch called 

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/bug-fixes-for-rc6

that has all the right magic sauce in it:

Konrad Rzeszutek Wilk (1):
      Revert "xen/mmu: Add workaround "x86-64, mm: Put early page table high""

Sedat Dilek (1):
      x86/mm: Fix section mismatch derived from native_pagetable_reserve()

Stefano Stabellini (1):
      x86,xen: introduce x86_init.mapping.pagetable_reserve

