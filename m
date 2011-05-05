Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab1EEOFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 10:05:05 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:17385 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467Ab1EEOFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 10:05:03 -0400
X-IronPort-AV: E=Sophos;i="4.64,319,1301875200"; 
   d="scan'208";a="5618377"
Date: Thu, 5 May 2011 15:06:18 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Daniel Kiper <dkiper@net-space.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 1/2] xen/mmu: Add workaround "x86-64, mm: Put early page
 table high"
In-Reply-To: <20110505140124.GD4386@dumpdata.com>
Message-ID: <alpine.DEB.2.00.1105051504500.10886@kaball-desktop>
References: <1304356942-17656-1-git-send-email-konrad.wilk@oracle.com> <1304356942-17656-2-git-send-email-konrad.wilk@oracle.com> <20110503005527.GA6735@router-fw-old.local.net-space.pl> <20110503151206.GA8868@dumpdata.com> <20110503195141.GA15775@router-fw-old.local.net-space.pl>
 <20110504185903.GA29903@router-fw-old.local.net-space.pl> <alpine.DEB.2.00.1105051133570.10886@kaball-desktop> <20110505140124.GD4386@dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 May 2011, Konrad Rzeszutek Wilk wrote:
> > In any case you are right about the fact that the change is not needed
> > on X86_32 so if it has any bad side effects on X86_32 we can always do
> 
> Why not? Can't you boot a 32-bit Dom0 on those machines?
> 

Because e820_end_of_low_ram_pfn() is not called on 32-bit,
find_low_pfn_range() is called instead and works differently.
AFAICT find_low_pfn_range() is not affected by the issue described in
the previous email.

