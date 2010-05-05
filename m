Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971Ab0EEUKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 16:10:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52002 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757481Ab0EEUKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 16:10:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: virtualization@lists.linux-foundation.org
Subject: Re: [Pv-drivers] RFC: Network Plugin Architecture (NPA) for vmxnet3
Date: Wed, 5 May 2010 22:09:48 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.34-rc6-00090-g1509e54-dirty; KDE/4.4.2; x86_64; ; )
Cc: Pankaj Thakkar <pthakkar@vmware.com>,
       Christoph Hellwig <hch@infradead.org>,
       Dmitry Torokhov <dtor@vmware.com>,
       "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20100504230225.GP8323@vmware.com> <20100505173951.GA8388@infradead.org> <F1354E79A137A24CBA60059AA65CB1B802A235C535@EXCH-MBX-2.vmware.com>
In-Reply-To: <F1354E79A137A24CBA60059AA65CB1B802A235C535@EXCH-MBX-2.vmware.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005052209.48465.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/g/M07hXck1W3jXBlXWHfFiOUpDVk/2yuubUN
 mtSh4JcgI3K0o2/mnmiGoXqMYznzexO7OoPZk5MfEEKXtCb2hk
 Rq71Gq/TFOgJ00qEObN9A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 May 2010 19:47:10 Pankaj Thakkar wrote:
> > 
> > Forget about the licensing.  Loading binary blobs written to a shim
> > layer is a complete pain in the ass and totally unsupportable, and
> > also uninteresting because of the overhead.
> 
> [PT] Why do you think it is unsupportable? How different is it from any module
> written against a well maintained interface? What overhead are you talking about?

We have the right number of module loaders in the kernel: one. If you
add another one, you're doubling the amount of code that anyone
working on that code needs to know about.
 
> > If you have any interesting in developing this further, do:
> > 
> >  (1) move the limited VF drivers directly into the kernel tree,
> >      talk to them through a normal ops vector
> [PT] This assumes that all the VF drivers would always be available.
> Also we have to support windows and our current design supports it
> nicely in an OS agnostic manner.

Your approach assumes that the plugin is always available, which has
exactly the same implications.

> >  (2) get rid of the whole shim crap and instead integrate the limited
> >      VF driver with the full VF driver we already have, instead of
> >      duplicating the code
> [PT] Having a full VF driver adds a lot of dependency on the guest VM
> and this is what NPA tries to avoid.

If you have the limited driver for some hardware that does not have
the real thing, we could still ship just that. I would however guess
that most vendors are interested in not just running in vmware but
also other hypervisors that still require the full driver, so that
case would be rare, especially in the long run.

	Arnd
