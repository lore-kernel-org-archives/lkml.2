Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab1HKQ7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 12:59:20 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:55043 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab1HKQ7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 12:59:18 -0400
Date: Thu, 11 Aug 2011 12:59:11 -0400
From: Tracey Dent <tdent48227@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, gregkh@suse.de
Subject: Re: [PATCH 1/1] misc/pti.c: Fix build error when PCI is not
 selected
Message-ID: <20110811165911.GA6454@tj-desktop>
References: <20110811162306.GA30710@tj-desktop>
 <20110811094520.4ee7819f.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110811094520.4ee7819f.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 09:45:20AM -0700, Randy Dunlap wrote:
> On Thu, 11 Aug 2011 12:23:06 -0400 Tracey Dent wrote:
> 
> > When you try to build INTEL_MID_PTI without having PCI
> > enabled. It fails like this-
> > 
> >  CC [M]  drivers/misc/pti.o
> >  drivers/misc/pti.c: In function ‘pti_pci_remove’:
> >  drivers/misc/pti.c:410: error: implicit declaration of function ‘pci_release_region’
> >  drivers/misc/pti.c: In function ‘pti_pci_probe’:
> >  drivers/misc/pti.c:859: error: implicit declaration of function ‘pci_request_region’
> > 
> > So make INTEL_MID_PTI depend on PCI to fix build error.
> 
> I think (hope) that Greg already has a patch like this queued.
> Greg- are you planning to push some patches soon?
> 
>

Okay, sorry for the noise then.
 
> > Signed-off-by: Tracey Dent <tdent48227@gmail.com>
> > ---
> >  drivers/misc/Kconfig |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> > index 0a4d86c..2d6423c 100644
> > --- a/drivers/misc/Kconfig
> > +++ b/drivers/misc/Kconfig
> > @@ -146,6 +146,7 @@ config PHANTOM
> >  
> >  config INTEL_MID_PTI
> >  	tristate "Parallel Trace Interface for MIPI P1149.7 cJTAG standard"
> > +	depends on PCI
> >  	default n
> >  	help
> >  	  The PTI (Parallel Trace Interface) driver directs
> > -- 
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***

regards,

Tracey Dent
