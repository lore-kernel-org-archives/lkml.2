Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab0EZMXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 08:23:35 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:13079 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab0EZMXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 08:23:32 -0400
X-IronPort-AV: E=Sophos;i="4.53,304,1272844800"; 
   d="scan'208";a="97771"
Date: Wed, 26 May 2010 13:27:26 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Don Dutile <ddutile@redhat.com>
Subject: Re: [PATCH 11/11] Unplug emulated disks and nics
In-Reply-To: <4BFC3390.4060503@goop.org>
Message-ID: <alpine.DEB.2.00.1005261325110.25605@kaball-desktop>
References: <alpine.DEB.2.00.1005241615300.25605@kaball-desktop> <1274725657-1149-11-git-send-email-stefano.stabellini@eu.citrix.com> <4BFC3390.4060503@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 May 2010, Jeremy Fitzhardinge wrote:
> Could you give this a bit more of a descriptive name, type and/or
> comment?  What is it indicating about the xen_platform_pci driver?  That
> it has been detected?  That it is in use?  That it can be used?  Is it
> boolean, or can it have any value?
> 
> 

It is boolean and it signals that the xen platform pci device can be
used. I'll add a comment and rename it to xen_platform_pci_enabled.


> > + */
> > +
> > +#ifndef _XEN_PLATFORM_PCI_H
> > +#define _XEN_PLATFORM_PCI_H
> > +
> > +#include <linux/version.h>
> >
> Why?
> 

It is needed for LINUX_VERSION_CODE, see below:

> > +
> > +#define XEN_IOPORT_MAGIC_VAL 0x49d2
> > +#define XEN_IOPORT_LINUX_PRODNUM 0xffff
> > +#define XEN_IOPORT_LINUX_DRVVER  ((LINUX_VERSION_CODE << 8) + 0x0)
> > +
> > +extern int xen_platform_pci;
> >
> 
> I still think these headers should be folded together.  There's no point
> in having them separate.  They describe an ABI, so there's no need to
> keep the files in sync with the master Xen sources (since the ABI will
> never change).
 
All right, I also agree with the other comments.
