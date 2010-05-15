Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab0EOMJH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 08:09:07 -0400
Received: from vs81.sauer-cs.de ([80.244.252.81]:58658 "EHLO kbdbabel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295Ab0EOMJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 08:09:05 -0400
Date: Sat, 15 May 2010 16:03:43 +0400 (MSD)
From: Alexander Kurz <linux@blala.de>
X-X-Sender: linux@blala.de
To: Frank Mori Hess <fmhess@users.sourceforge.net>
cc: Greg KH <greg@kroah.com>, Alexander Kurz <linux@blala.de>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, Ian Abbott <abbotti@mev.co.uk>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/comedi: new Kconfig and Makefiles, drivers
 grouped by bustype.
In-Reply-To: <201005142029.37408.fmhess@speakeasy.net>
Message-ID: <alpine.DEB.1.10.1005151601510.26254@blala.de>
References: <alpine.DEB.1.10.1005081218220.5727@blala.de> <20100514190142.GA2505@kroah.com> <201005142029.37408.fmhess@speakeasy.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 14 May 2010, Frank Mori Hess wrote:

> On Friday 14 May 2010, Greg KH wrote:
> > Wow.  Is this something that we really want?  That's a lot of new
> > Kconfig options, and while it seems like it makes sense, I would like to
> > get the comedi developers opinion here.
> 
> It doesn't matter to me how granular the Kconfig stuff is.  Personally, the 
> only thing I tend to do is disable are the pcmcia drivers as a group on 
> desktop machines.  Also, I noticed in the patch it includes the 8255 
> module as part of the PCI and ISA groups, but not PCMCIA.  But it is used 
> by some of the PCMCIA drivers as well.
> 
Hm, I cannot see a build-dependancy from any of the PCMCIA-Modules
to 8255.c. All PCMCIA-modules do build and load fine without compiling 
8255.c. There is a dependancy from das08_cs (PCMCIA) to das08 (ISA) via
config COMEDI_DAS08_CS select COMEDI_DAS08.
This will lead to a hidden select of COMEDI_DAS08 when 
COMEDI_ISA_DRIVERS is not enabled.
Is there something that I have missed?

