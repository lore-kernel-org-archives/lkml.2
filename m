Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab1K3HL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 02:11:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab1K3HLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 02:11:55 -0500
Date: Wed, 30 Nov 2011 09:13:21 +0200
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
Message-ID: <20111130071321.GB17781@redhat.com>
References: <cover.1322592494.git.mst@redhat.com>
 <a3bc9cb56040258dabc7b466ea217f4515b68b7d.1322592495.git.mst@redhat.com>
 <201111292205.11544.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111292205.11544.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 10:05:11PM +0000, Arnd Bergmann wrote:
> On Tuesday 29 November 2011, Michael S. Tsirkin wrote:
> > diff --git a/arch/tile/include/asm/io.h b/arch/tile/include/asm/io.h
> > index c9ea165..be6090d 100644
> > --- a/arch/tile/include/asm/io.h
> > +++ b/arch/tile/include/asm/io.h
> > @@ -204,7 +204,8 @@ static inline long ioport_panic(void)
> >  
> >  static inline void __iomem *ioport_map(unsigned long port, unsigned int len)
> >  {
> > -       return (void __iomem *) ioport_panic();
> > +       pr_info("Trying to map an IO resource - it does not exit on tile.\n");
> > +       return NULL;
> >  }
> 
> Why not just set CONFIG_NO_IOPORT and make this unavailable at compile time?
> 
> 	Arnd

Well I think CONFIG_NO_IOPORT only has effect if you pull in asm-generic/io.h.
This might work but I have no idea. Presumably whoever wrote that architecture
considered and discarded setting GENERIC_IOMAP.

-- 
MST
