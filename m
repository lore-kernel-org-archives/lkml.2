Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab0EEVxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 17:53:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62376 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab0EEVxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 17:53:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dmitry Torokhov <dtor@vmware.com>
Subject: Re: [Pv-drivers] RFC: Network Plugin Architecture (NPA) for vmxnet3
Date: Wed, 5 May 2010 23:53:15 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.34-rc6-00090-g1509e54-dirty; KDE/4.4.2; x86_64; ; )
Cc: "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       Pankaj Thakkar <pthakkar@vmware.com>,
       Christoph Hellwig <hch@infradead.org>,
       "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20100504230225.GP8323@vmware.com> <201005052209.48465.arnd@arndb.de> <201005051336.32712.dtor@vmware.com>
In-Reply-To: <201005051336.32712.dtor@vmware.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005052353.16544.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19L3MInH9w2nK/cjCsmMepZEGwNTyPtBMGaec1
 9CJX/ardiHWvA9cbVvWHdUU69uoRlWSznV1QAKiWoJmMrtnW7L
 oLC/fovHrn4zdF9PtXpQQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 May 2010 22:36:31 Dmitry Torokhov wrote:
> 
> On Wednesday 05 May 2010 01:09:48 pm Arnd Bergmann wrote:
> > > > If you have any interesting in developing this further, do:
> > > > 
> > > >  (1) move the limited VF drivers directly into the kernel tree,
> > > >      talk to them through a normal ops vector
> > > 
> > > [PT] This assumes that all the VF drivers would always be available.
> > > Also we have to support windows and our current design supports it
> > > nicely in an OS agnostic manner.
> > 
> > Your approach assumes that the plugin is always available, which has
> > exactly the same implications.
> 
> Since plugin[s] are carried by the host they are indeed always
> available.

But what makes you think that you can build code that can be linked
into arbitrary future kernel versions? The kernel does not define any
calling conventions that are stable across multiple versions or
configurations. For example, you'd have to provide different binaries
for each combination of

- 32/64 bit code
- gcc -mregparm=?
- lockdep
- tracepoints
- stackcheck
- NOMMU
- highmem
- whatever new gets merged

If you build the plugins only for specific versions of "enterprise" Linux
kernels, the code becomes really hard to debug and maintain.
If you wrap everything in your own version of the existing interfaces, your
code gets bloated to the point of being unmaintainable.

So I have to correct myself: this is very different from assuming the
driver is available in the guest, it's actually much worse.

	Arnd
