Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab2C0QzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 12:55:21 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:9209 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590Ab2C0QzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 12:55:17 -0400
X-IronPort-AV: E=Sophos;i="4.75,327,1330905600"; 
   d="scan'208";a="11583133"
Date: Tue, 27 Mar 2012 17:56:16 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 1/2] xen: enter/exit lazy_mmu_mode around m2p_override
 calls
In-Reply-To: <20120327143142.GA31081@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.00.1203271737280.15151@kaball-desktop>
References: <1332856364-29995-1-git-send-email-stefano.stabellini@eu.citrix.com> <20120327143142.GA31081@phenom.dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2012, Konrad Rzeszutek Wilk wrote:
> On Tue, Mar 27, 2012 at 02:52:43PM +0100, Stefano Stabellini wrote:
> > This patch is a significant performance improvement for the
> 
> How much? 10%? 90%?

I think you are overestimating the meaning of "significant" :)

It is about 6% using grant_table and 2% using blkback.


> > m2p_override.
> 
> Can you explain what those calls do in the git commit description please?

Right, I have been way too concise.

Each m2p_add/remove_override call issues a MULTI_grant_table_op and a
__flush_tlb_single if kmap_op != NULL.
Batching all the calls together is a great performance benefit because
it means issuing one hypercall total rather than two hypercall per page.

I'll resend with a proper commit message.
