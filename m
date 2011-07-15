Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964957Ab1GOCzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 22:55:09 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:41062 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964801Ab1GOCzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 22:55:05 -0400
Date: Thu, 14 Jul 2011 22:52:46 -0400 (EDT)
From: Peter Foley <pefoley2@verizon.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Peter Foley <pefoley2@verizon.net>, Michal Marek <mmarek@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: prevent unnecessary rebuilding due to
 config_data.gz
In-reply-to: <20110706083329.9755dc70.rdunlap@xenotime.net>
Message-id: <alpine.LNX.2.00.1107142252160.59744@linux>
References: <alpine.LNX.2.00.1107051741390.20637@linux>
 <20110706083329.9755dc70.rdunlap@xenotime.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jul 2011, Randy Dunlap wrote:

> On Tue, 05 Jul 2011 19:42:18 -0400 (EDT) Peter Foley wrote:
> 
> > When IKCONFIG is built-in make oldconfig will cause the kernel to be 
> > relinked even if .config didn't change. This happens because of a 
> > config_data.gz dependency on .config. This patch changes the if_changed to 
> > a filechk so that config_data.h is only rebuilt when the contents 
> > have actually changed.
> > 
> > Signed-off-by: Peter Foley <pefoley2@verizon.net>
> 
> Michal,
> If this looks OK to you, please merge it.
> 
> Thanks.
> 
> > ---
> >  kernel/Makefile |    5 ++---
> >  1 files changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/kernel/Makefile b/kernel/Makefile
> > index 2d64cfc..d06467f 100644
> > --- a/kernel/Makefile
> > +++ b/kernel/Makefile
> > @@ -125,11 +125,10 @@ targets += config_data.gz
> >  $(obj)/config_data.gz: $(KCONFIG_CONFIG) FORCE
> >  	$(call if_changed,gzip)
> >  
> > -quiet_cmd_ikconfiggz = IKCFG   $@
> > -      cmd_ikconfiggz = (echo "static const char kernel_config_data[] __used = MAGIC_START"; cat $< | scripts/bin2c; echo "MAGIC_END;") > $@
> > +      filechk_ikconfiggz = (echo "static const char kernel_config_data[] __used = MAGIC_START"; cat $< | scripts/bin2c; echo "MAGIC_END;")
> >  targets += config_data.h
> >  $(obj)/config_data.h: $(obj)/config_data.gz FORCE
> > -	$(call if_changed,ikconfiggz)
> > +	$(call filechk,ikconfiggz)
> >  
> >  $(obj)/time.o: $(obj)/timeconst.h
> >  
> > -- 
> 
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 

Ping?
