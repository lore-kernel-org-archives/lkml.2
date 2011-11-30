Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509Ab1K3P6C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 10:58:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850Ab1K3P57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 10:57:59 -0500
Date: Wed, 30 Nov 2011 17:59:25 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Metcalf <cmetcalf@tilera.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Paul Mundt <lethal@linux-sh.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH-RFC 1/2] tile: don't panic on iomap
Message-ID: <20111130155925.GA25812@redhat.com>
References: <cover.1322592494.git.mst@redhat.com>
 <201111301404.41544.arnd@arndb.de>
 <20111130143122.GC21413@redhat.com>
 <201111301549.57430.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111301549.57430.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 03:49:57PM +0000, Arnd Bergmann wrote:
> On Wednesday 30 November 2011, Michael S. Tsirkin wrote:
> > On Wed, Nov 30, 2011 at 02:04:41PM +0000, Arnd Bergmann wrote:
> >
> > > Ah, right. I didn't realize that the generic pci_iomap still attempts
> > > to call ioport_map(). It would probably make sense to enclose
> > > the ioport_map() call in pci_iomap() inside of #ifdef CONFIG_HAS_IOPORT.
> > > It's not exactly beautiful, but probably the most correct solution
> > > so that we can make any call to ioport_map() a build-time error on
> > > architectures that set CONFIG_NO_IOPORT.
> > 
> > I'm not sure why do you want to do that.
> > 
> 
> The problem is that any definition of ioport_map on architectures
> that can't do it is potentially harmful. Calling panic() is
> bad style as you pointed out, but simply returning NULL can
> also be harmful because it's likely that some drivers are written
> under the (false) assumption that ioport_map can never fail.
> Getting a build-time error would be more helpful here IMHO.
> 
> 	Arnd

Yes but uglifying these users is also bad, ifdefs in code are incredibly
fragile. Isn't it enough to declare ioport_map __must_check?

-- 
MST
