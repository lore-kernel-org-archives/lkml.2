Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab1I2OyE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 10:54:04 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:5712 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289Ab1I2OyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 10:54:02 -0400
X-IronPort-AV: E=Sophos;i="4.68,461,1312156800"; 
   d="scan'208";a="8132765"
Date: Thu, 29 Sep 2011 15:53:47 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH v5 2/2] xen: modify kernel mappings corresponding
 to granted pages
In-Reply-To: <1317305884.26672.190.camel@zakaz.uk.xensource.com>
Message-ID: <alpine.DEB.2.00.1109291550250.3519@kaball-desktop>
References: <alpine.DEB.2.00.1109291148340.3519@kaball-desktop>  <1317293876-23891-2-git-send-email-stefano.stabellini@eu.citrix.com>  <20110929135558.GA31321@phenom.oracle.com> <1317305884.26672.190.camel@zakaz.uk.xensource.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Sep 2011, Ian Campbell wrote:
> On Thu, 2011-09-29 at 14:55 +0100, Konrad Rzeszutek Wilk wrote:
> > >  /* Xen machine address */
> > > @@ -31,8 +32,10 @@ typedef struct xpaddr {
> > >  #define INVALID_P2M_ENTRY	(~0UL)
> > >  #define FOREIGN_FRAME_BIT	(1UL<<(BITS_PER_LONG-1))
> > >  #define IDENTITY_FRAME_BIT	(1UL<<(BITS_PER_LONG-2))
> > > +#define GRANT_FRAME_BIT	(1UL<<(BITS_PER_LONG-3))
> > 
> > I am going to change that to (BITS_PER_LONG-1) as we aren't
> > using the P2M. (and add that comment in the file).
> 
> You should also move it away from/out of the "/**** MACHINE <-> PHYSICAL
> CONVERSION MACROS ****/" section, otherwise it's just confusing.
> 
> The associated GRANT_FRAME macro seems to be unused.
> 
> But what is that bit in page->private actually used for? This patch adds
> it in m2p_add_override and masks it off in m2p_find_override, but
> doesn't otherwise appear to use it.

It was needed by the previous version that was capable of handling
highmem pages, it is not required anymore.
