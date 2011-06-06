Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731Ab1FFPxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 11:53:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59646 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757336Ab1FFPxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 11:53:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH 7/7] [v2] drivers/misc: introduce Freescale hypervisor management driver
Date: Mon, 6 Jun 2011 17:53:09 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Timur Tabi <timur@freescale.com>, kumar.gala@freescale.com,
        linux-kernel@vger.kernel.org, akpm@kernel.org,
        linux-console@vger.kernel.org, greg@kroah.com,
        linuxppc-dev@lists.ozlabs.org
References: <1306953337-15698-1-git-send-email-timur@freescale.com> <201106031728.43707.arnd@arndb.de> <20110603112213.4f4d1b4e@schlenkerla.am.freescale.net>
In-Reply-To: <20110603112213.4f4d1b4e@schlenkerla.am.freescale.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106061753.10154.arnd@arndb.de>
X-Provags-ID: V02:K0:NX4T4Kvbi7arhAXFoCUGmo0I9YHIv+jkGnZcTrFOGTF
 Z+UGgcgncPyTKN7DUnIN58wZaUqrPH/udisXKAPg/MZwv31RyS
 w5312pt35oeMz5ODS76eJlRu/LOUlFhYcUDOIGNtMhHym8hjFu
 iFTU+8hYHjOLXgvuLE1Qzxrbi6rjd+4vIjAyzAHSxgC0Wig3Ni
 +yAKS5bgj9LK9rsuyeTig==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 June 2011, Scott Wood wrote:
> On Fri, 3 Jun 2011 17:28:43 +0200
> Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > On Thursday 02 June 2011, Scott Wood wrote:
> > > I wanted to have the hypervisor take an update dtb (we already have special
> > > meta-properties for things like deletion as part of the hv config
> > > mechanism).  But others on the project wanted to keep it simple, and so
> > > get/set property it was. :-/
> > > 
> > > It's unlikely to change at this point without a real need.
> > > 
> > > As for a filesystem interface, it's not a good match either. 
> > > You can't iterate over anything to read out the full tree from the hv.
> > 
> > kexec iterates over /proc/device-tree to create a dts blob.
> 
> That's irrelevant, because we're not talking about that device tree.  We're
> talking about the device tree of another hypervisor guest.

I understand that it's a different device tree. That doesn't mean we
can't use the same tools.

> > > You can't delete anything. 
> > 
> > rm, rmdir
> > 
> > > You can't create empty nodes.
> > 
> > mkdir
> 
> I know how to operate a filesystem.  You can't do these operations *on
> another guest's device tree through the hv interface*.

Why not? From a device driver perspective, it's not much of a difference
whether you export a device (or hypervisor, firmware, ...) setting
as an ioctl or an inode operation.

> > > There would still be other ioctls needed for starting/stopping the
> > > partition, etc.
> > 
> > Right, although you could model them as a file interface as well.
> > KVMfs is one example doing that.
> 
> And what would be the benefit of this major restructuring and added
> complexity?

I think it would be a slightly better abstraction, and the complexity
is not as big as you make it sound. I'm mainly countering your statement
that it would be a bad interface or that would not possible to do.

I'm not that opposed to having an ioctl interface for your hypervisor
interface, but I am opposed to making design choices based on
a bad representations of facts or not having considered the options
that other people suggest.

	Arnd
