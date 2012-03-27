Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab2C0QgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 12:36:12 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:19868 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab2C0QgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 12:36:11 -0400
X-IronPort-AV: E=Sophos;i="4.75,327,1330905600"; 
   d="scan'208";a="11582395"
Date: Tue, 27 Mar 2012 17:37:07 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 2/2] m2p_find_override: use list_for_each_entry_safe
In-Reply-To: <20120327142654.GA30655@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.00.1203271733370.15151@kaball-desktop>
References: <1332856364-29995-1-git-send-email-stefano.stabellini@eu.citrix.com> <1332856364-29995-2-git-send-email-stefano.stabellini@eu.citrix.com> <20120327142654.GA30655@phenom.dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2012, Konrad Rzeszutek Wilk wrote:
> On Tue, Mar 27, 2012 at 02:52:44PM +0100, Stefano Stabellini wrote:
> > Use list_for_each_entry_safe and remove the spin_lock acquisition in
> > m2p_find_override.
> 
> So this would allow us to get stale entries. Is that OK?

I think it is reasonable.
In practice we should never get an m2p_find_override call looking for an
entry that we are about to add/delete.
