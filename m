Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab2DZLLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 07:11:10 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:11247 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231Ab2DZLLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 07:11:08 -0400
X-IronPort-AV: E=Sophos;i="4.75,485,1330905600"; 
   d="scan'208";a="12152568"
Date: Thu, 26 Apr 2012 12:17:21 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: David Vrabel <david.vrabel@citrix.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "tobias.geiger@vido.info" <tobias.geiger@vido.info>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH] xen: use the pirq number to check the
 pirq_eoi_map
In-Reply-To: <4F991FF1.6000007@citrix.com>
Message-ID: <alpine.DEB.2.00.1204261216030.26786@kaball-desktop>
References: <1335366698-19875-1-git-send-email-stefano.stabellini@eu.citrix.com> <4F991FF1.6000007@citrix.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2012, David Vrabel wrote:
> On 25/04/12 16:11, Stefano Stabellini wrote:
> > In pirq_check_eoi_map use the pirq number rather than the Linux irq
> > number to check whether an eoi is needed in the pirq_eoi_map.
> 
> What buggy behaviour does this patch fix?  It would be nice if this was
> included in the patch description.

The irq number is not always identical to the pirq number so if we
wrongly use the irq number to check the pirq_eoi_map we are going to
check for the wrong pirq to EOI. As a consequence some interrupts might
not be EOI'ed by the guest correctly.
