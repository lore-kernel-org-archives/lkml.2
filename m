Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859Ab2J3PsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 11:48:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42285 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab2J3PsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 11:48:05 -0400
Date: Tue, 30 Oct 2012 08:48:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dmitry Torokhov <dtor@vmware.com>
Cc: George Zhang <georgezhang@vmware.com>, pv-drivers@vmware.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [Pv-drivers] [PATCH 00/12] VMCI for Linux upstreaming
Message-ID: <20121030154801.GC14167@kroah.com>
References: <20121030005923.17788.21797.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20121030021938.GC1920@kroah.com>
 <20121030040744.GB32055@dtor-ws.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121030040744.GB32055@dtor-ws.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 09:07:44PM -0700, Dmitry Torokhov wrote:
> Hi Greg,
> 
> On Mon, Oct 29, 2012 at 07:19:38PM -0700, Greg KH wrote:
> > On Mon, Oct 29, 2012 at 06:03:28PM -0700, George Zhang wrote:
> > >  drivers/misc/Kconfig                      |    1
> > >  drivers/misc/Makefile                     |    2
> > >  drivers/misc/vmw_vmci/Kconfig             |   16
> > >  drivers/misc/vmw_vmci/Makefile            |   43
> > 
> > Meta comment here, why drivers/misc/?  The other hypervisor
> > infrastructures all have their own directory under drivers/  Should we
> > be moving everything to drivers/hyperv/ somehow?
> 
> drivers/hyperv is not the best name for obvious reasons...

Sorry, yes :)

> I think that even if we had a special directory for vmci having network
> drivers in Dave's realm and pvscsi in James's is best option, so the new
> directory would contain vmci and the balloon driver (vsock will go into
> net/).  Given that balloon is already in drivers/misc it looked like
> obvious place for VMCI as well.

I agree that the individual drivers should go in the subsystem area,
it's this "hypervisor bus core" type code that I'm questioning.  Right
now every hypervisor is putting that logic in a different place in the
kernel, having some consistency here would be nice.

thanks,

greg k-h
