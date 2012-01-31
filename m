Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab2AaQi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 11:38:59 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:48553 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab2AaQi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 11:38:58 -0500
X-IronPort-AV: E=Sophos;i="4.71,596,1320624000"; 
   d="scan'208";a="10397603"
Date: Tue, 31 Jan 2012 16:40:26 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen pvhvm: do not remap pirqs onto evtchns if
 !xen_have_vector_callback
In-Reply-To: <20120131162759.GA18248@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.00.1201311636380.3196@kaball-desktop>
References: <alpine.DEB.2.00.1201301429530.3196@kaball-desktop> <20120131162759.GA18248@phenom.dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jan 2012, Konrad Rzeszutek Wilk wrote:
> On Mon, Jan 30, 2012 at 02:31:46PM +0000, Stefano Stabellini wrote:
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> So the xen_have_vector_callback looks to be only set by
> 
> 1398         if (xen_feature(XENFEAT_hvm_callback_vector))
> 1399                 xen_have_vector_callback = 1;
> 
> So could this be just done via a check for that instead?
> 

Sure, but I don't think it would be better: using
xen_have_vector_callback is more consistent and give us the flexibility
of allowing users to manually override it in the future.
