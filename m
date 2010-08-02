Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375Ab0HBQo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 12:44:26 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:38671 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab0HBQoY (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 2 Aug 2010 12:44:24 -0400
Date: Mon, 2 Aug 2010 12:42:34 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, hpa@zytor.com
Cc: jeremy@goop.org, Ian.Campbell@citrix.com, albert_herranz@yahoo.es,
        x86@kernel.org, linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        iommu@lists.linux-foundation.org, tglx@linutronix.de
Subject: Re: [PATCH 9/9] x86: Detect whether we should use Xen SWIOTLB.
Message-ID: <20100802164234.GC6961@phenom.dumpdata.com>
References: <4C56E49E.6070102@zytor.com>
 <20100803004252B.fujita.tomonori@lab.ntt.co.jp>
 <4C56E8A9.1060004@zytor.com>
 <20100803010025R.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100803010025R.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4C56F5B9.034B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 01:01:08AM +0900, FUJITA Tomonori wrote:
> On Mon, 02 Aug 2010 08:47:53 -0700
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
> > On 08/02/2010 08:43 AM, FUJITA Tomonori wrote:
> > > 
> > > That's the difficult part because IOMMUs are not
> > > interdependent. Hardware IOMMUs are related with swiotlb. GART and
> > > AMD-IOMMU are too.
> > > 
> > > We could invent sorta IOMMU register interface and driver-ize IOMMUs
> > > but they can't be interdependent completely.
> > 
> > Of course.  However, we need there to be as much structure to it as
> > there can be.
> 
> Ok, let's see if Konrad can invent something clean.

<chuckles> Thank you for your vote of confidence.
> 
> But his attempt to create "swiotlb iommu function array" and "hardware
> iommu function array" looks like to makes the code more unreadable.

Let me go to my favorite coffee shop and think this one through.
Can I get concession for putting the original patch in (the simple, dumb one),
and then:
 - start working on the IOMMU register interface without having to try
   to get it done for 2.6.36, and
 - do the driverization as a seperate cleanup.

