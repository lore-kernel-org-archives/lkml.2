Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab2HAQIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 12:08:04 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:61661 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab2HAQIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 12:08:01 -0400
X-IronPort-AV: E=Sophos;i="4.77,694,1336348800"; 
   d="scan'208";a="13807782"
Date: Wed, 1 Aug 2012 17:07:42 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Xen-devel] [PATCH 04/24] xen/arm: sync_bitops
In-Reply-To: <20120801143551.GI7227@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1208011707280.4645@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com> <1343316846-25860-4-git-send-email-stefano.stabellini@eu.citrix.com> <20120726163759.GE9222@phenom.dumpdata.com> <1343381305.6812.116.camel@zakaz.uk.xensource.com>
 <20120801143551.GI7227@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2012, Konrad Rzeszutek Wilk wrote:
> On Fri, Jul 27, 2012 at 10:28:25AM +0100, Ian Campbell wrote:
> > On Thu, 2012-07-26 at 17:37 +0100, Konrad Rzeszutek Wilk wrote:
> > > On Thu, Jul 26, 2012 at 04:33:46PM +0100, Stefano Stabellini wrote:
> > > > sync_bitops functions are equivalent to the SMP implementation of the
> > > > original functions, independently from CONFIG_SMP being defined.
> > > 
> > > So why can't the code be changed to use that? Is it that
> > > the _set_bit, _clear_bit, etc are not available with !CONFIG_SMP?
> > 
> > _set_bit etc are not SMP safe if !CONFIG_SMP. But under Xen you might be
> > communicating with a completely external entity who might be on another
> > CPU (e.g. two uniprocessor guests communicating via event channels and
> > grant tables). So we need a variant of the bit ops which are SMP safe
> > even on a UP kernel.
> > 
> > The users are common code and the sync_foo vs foo distinction matters on
> > some platforms (e.g. x86 where a UP kernel would omit the LOCK prefix
> > for the normal ones).
> 
> OK, that makes sense. Stefano can you include that comment in the git
> commit description and in the sync_bitops.h file please?

Yep, I'll do that.

