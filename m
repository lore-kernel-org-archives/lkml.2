Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab1K3ScW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 13:32:22 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:62909 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab1K3ScS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 13:32:18 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH-RFC 1/2] tile: don't panic on iomap
Date: Wed, 30 Nov 2011 18:32:11 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Chris Metcalf <cmetcalf@tilera.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Paul Mundt <lethal@linux-sh.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
References: <cover.1322592494.git.mst@redhat.com> <201111301549.57430.arnd@arndb.de> <20111130155925.GA25812@redhat.com>
In-Reply-To: <20111130155925.GA25812@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111301832.11578.arnd@arndb.de>
X-Provags-ID: V02:K0:3ErVgRecTSoASJuI2FOU9S7N1AfU7WouIaXByDXJCgq
 Tsqu+1Piatn2TUoHBVIAS1pLlH+IK+kXHUc4cxlS5Ylqfp31Vh
 40lkXa3WYM7vvk1I+XFPdf6YQY4y1sbtdLldvnPPh5jlJS9/0i
 A5A8kZ2OGZHKCqUCqow9116EwCGDE2A+jXte31wLqNBfGbve2a
 jVhFvciNSzeRX780GVPMH5X5wnqxMYLSOo3oxtkCEkv7pN4aqq
 emURFyNyEpLGN5I0ClvNF5s+ccd1QjXQVaaEXesJTXSa4qWo0l
 MARKAOdF0tmWPloJEojpn/UBm86lfZd9cC9DlVsNWOl2fPtpmD
 U729kIEFdGkYB2IpOzhQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 November 2011, Michael S. Tsirkin wrote:
> On Wed, Nov 30, 2011 at 03:49:57PM +0000, Arnd Bergmann wrote:
> > On Wednesday 30 November 2011, Michael S. Tsirkin wrote:
> > > On Wed, Nov 30, 2011 at 02:04:41PM +0000, Arnd Bergmann wrote:
> > >
> > > > Ah, right. I didn't realize that the generic pci_iomap still attempts
> > > > to call ioport_map(). It would probably make sense to enclose
> > > > the ioport_map() call in pci_iomap() inside of #ifdef CONFIG_HAS_IOPORT.
> > > > It's not exactly beautiful, but probably the most correct solution
> > > > so that we can make any call to ioport_map() a build-time error on
> > > > architectures that set CONFIG_NO_IOPORT.
> > > 
> > > I'm not sure why do you want to do that.
> > > 
> > 
> > The problem is that any definition of ioport_map on architectures
> > that can't do it is potentially harmful. Calling panic() is
> > bad style as you pointed out, but simply returning NULL can
> > also be harmful because it's likely that some drivers are written
> > under the (false) assumption that ioport_map can never fail.
> > Getting a build-time error would be more helpful here IMHO.
> 
> Yes but uglifying these users is also bad, ifdefs in code are incredibly
> fragile. Isn't it enough to declare ioport_map __must_check?

I guess we already wasted too many electrons over this triviality,
I don't actually care all that much, and will probably have to
touch the same code again when I get to submit my patch to make
inb/outb optional for architectures. Just pick any solution (including
your original one). I'll revisit this when I'm bothered by the
presence of the ioport_map function and will keep you in the loop
on those patches.

	Arnd
