Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab2A3UFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 15:05:04 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:63041 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab2A3UFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 15:05:01 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 1/3] lib: add NO_GENERIC_PCI_IOPORT_MAP
Date: Mon, 30 Jan 2012 20:04:32 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Kevin Cernekee <cernekee@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Myron Stowe <myron.stowe@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        James Morris <jmorris@namei.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Michael Witten <mfwitten@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-arch@vger.kernel.org
References: <cover.1327877053.git.mst@redhat.com> <201201301551.46907.arnd@arndb.de> <20120130161818.GA9345@redhat.com>
In-Reply-To: <20120130161818.GA9345@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201302004.33083.arnd@arndb.de>
X-Provags-ID: V02:K0:ZNS912xatw+iD7ZLS287Q+NKxYf+kk+kMcCGVS81KSq
 wi9DOEBYVVloDKXEFGDv0RhA1yuMgB3Ot0m75Y8aynC/BPnIlQ
 yrDEqVE8kbqoV+ZbBijJ5vbhJ67xHzebv+Eoen9iODbyQv/Pak
 hMWqI6Yzt9tTZU/8owt/TQ2bYuD9KgrHJU6G0oXnt5sB/8cKkR
 rbzJb2EMH7D5Omd9fVVvZo9Uhep7m7Yw6fJvtO+fb9N+0gc41n
 AtPE5Fg4Y1s9rJYq6dYwaUl9rZOaah/sVWQbCEHxhftG+1D5Bx
 GIC93MoyUw2RIC3xnUiFwNPQEGRG4YQ8byVanFX+lr66athX3w
 2HohRC9RBsKHDtIFneTI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 January 2012, Michael S. Tsirkin wrote:
> > 
> > +/*
> > + * Create a virtual mapping cookie for a port on a given PCI device.
> > + * Do not call this directly, it exists to make it easier for architectures
> > + * to override.
> > + */
> > +#ifdef CONFIG_NO_GENERIC_PCI_IOPORT_MAP
> > +extern void __iomem *__pci_ioport_map(struct pci_dev *dev, unsigned long port,
> > +                                     unsigned int nr);
> > +#else
> > +static inline void __iomem *__pci_ioport_map(struct pci_dev *dev,
> > +                              unsigned long port, unsigned int nr)
> > +{
> > +       return ioport_map(port, nr);
> > +}
> > +#endif
> > 
> >       Arnd
> 
> It would be nicer in that it would
> make the kernel a bit smaller for generic architectures
> but this would need to go into a separate header:
> it depends on io.h and io.h depends on pci_iomap.h.

Adding extra dependencies is not good here, I agree.
Maybe  a better solution is to use a macro instead of an inline
function then:

#define  __pci_ioport_map(dev, port, nr) ioport_map(port, nr)

In general, macros should be avoided, but I think it's the
best tradeoff in this case.

	Arnd
