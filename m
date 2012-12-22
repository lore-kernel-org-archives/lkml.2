Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab2LVDKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 22:10:43 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:18194 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab2LVDKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 22:10:41 -0500
Date: Fri, 21 Dec 2012 22:10:19 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 24/27] x86: Add swiotlb force off support
Message-ID: <20121222031019.GA4120@phenom.dumpdata.com>
References: <1355814959-10573-1-git-send-email-yinghai@kernel.org>
 <1355814959-10573-25-git-send-email-yinghai@kernel.org>
 <20121222023741.GF3468@phenom.dumpdata.com>
 <87bodmhkns.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bodmhkns.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 06:42:47PM -0800, Eric W. Biederman wrote:
> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> writes:
> 
> > On Mon, Dec 17, 2012 at 11:15:56PM -0800, Yinghai Lu wrote:
> >> So use could disable swiotlb from command line, even swiotlb support
> >> is compiled in.  Just like we have intel_iommu=on and intel_iommu=off.
> >
> > You really need to spell out why this is useful.
> 
> YH why can't we safely autodetect that the swiotlb is unusable when
> there is no memory below 4G free?

I am not sure what 'YH' stands for (Yeah?).

However we could turn SWIOTLB off altogether if it cannot allocate
_some_ memory. It could try first 64MB, then 32MB, lastly 16MB. And
if all that fails - print a nice warning and continue on.

Later in the late initialization phase, when pci_swiotlb_late_init
is called - it can then figure out whether 'iommu' has been set
and it iself was never able to allocate. At that point it can try
the dynamic allocation (swiotlb_late_init_with_default_size)
... and if that fails give up and panic.
