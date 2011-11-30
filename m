Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393Ab1K3PuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 10:50:16 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:60335 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360Ab1K3PuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 10:50:12 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH-RFC 1/2] tile: don't panic on iomap
Date: Wed, 30 Nov 2011 15:49:57 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Chris Metcalf <cmetcalf@tilera.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Paul Mundt <lethal@linux-sh.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
References: <cover.1322592494.git.mst@redhat.com> <201111301404.41544.arnd@arndb.de> <20111130143122.GC21413@redhat.com>
In-Reply-To: <20111130143122.GC21413@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111301549.57430.arnd@arndb.de>
X-Provags-ID: V02:K0:Qg3WIJgufit+/YpxU96P87ABVT5e9IGhlGOA5N++dKU
 Qe7+fhyVJGwsFZSXYzOHDBfGDm7c2wc4zglAksLXk+inJEeDRd
 hqZttk14lYbyZqM+1tMx01e+KJ4TntrEWWS287kvlOrD7En3vO
 xS5r0XGGy+7GiMrIquAJLeM2m0B/rulS4jBLib0TNSXaGHdFUh
 AP0CZKhkA51Ltu9127m5ksgLvBbelDjKnslEC+9YpcZeCqok1b
 3rTdCfdvuYmVPdUVNXhQciHQUhNsC0jpQe5FM3NUDlUpjxSH4d
 D56a4t1gXeMR3zWfPLmA5h2P87ifDlGH+uHktdLajjluRZ/iyF
 pe8QRgVIncwmnstkeYyM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 November 2011, Michael S. Tsirkin wrote:
> On Wed, Nov 30, 2011 at 02:04:41PM +0000, Arnd Bergmann wrote:
>
> > Ah, right. I didn't realize that the generic pci_iomap still attempts
> > to call ioport_map(). It would probably make sense to enclose
> > the ioport_map() call in pci_iomap() inside of #ifdef CONFIG_HAS_IOPORT.
> > It's not exactly beautiful, but probably the most correct solution
> > so that we can make any call to ioport_map() a build-time error on
> > architectures that set CONFIG_NO_IOPORT.
> 
> I'm not sure why do you want to do that.
> 

The problem is that any definition of ioport_map on architectures
that can't do it is potentially harmful. Calling panic() is
bad style as you pointed out, but simply returning NULL can
also be harmful because it's likely that some drivers are written
under the (false) assumption that ioport_map can never fail.

Getting a build-time error would be more helpful here IMHO.

	Arnd
