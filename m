Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205Ab1JFTuO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 15:50:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759154Ab1JFTuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 15:50:12 -0400
Date: Thu, 6 Oct 2011 15:50:07 -0400
From: Dave Jones <davej@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: virtualbox tainting.
Message-ID: <20111006195007.GA24900@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Greg KH <greg@kroah.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20111006190526.GA13883@redhat.com>
 <20111006194432.GA21642@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111006194432.GA21642@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 12:44:32PM -0700, Greg Kroah-Hartman wrote:
 
 > > diff --git a/kernel/module.c b/kernel/module.c
 > > index 04379f92..d26c9a3 100644
 > > --- a/kernel/module.c
 > > +++ b/kernel/module.c
 > > @@ -2653,6 +2653,10 @@ static int check_module_license_and_versions(struct module *mod)
 > >  	if (strcmp(mod->name, "ndiswrapper") == 0)
 > >  		add_taint(TAINT_PROPRIETARY_MODULE);
 > >  
 > > +	/* vbox is garbage. */
 > > +	if (strcmp(mod->name, "vboxdrv") == 0)
 > > +		add_taint(TAINT_CRAP);
 > 
 > Odds are we should have a list of these types of modules, as I think
 > there are a few others out there we should mark this way :)

possibly, though this is by far the leader (for us at least) today.

 > But anyway, I like this, and I think I'll go add it to the openSUSE
 > kernels so we can avoid the numerous bug reports we get there as well
 > for this crappy driver.
 > 
 > 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

I feel a bit dirty overloading TAINT_CRAP (even if the name is apropos).
Should I introduce a TAINT_OUT_OF_TREE perhaps instead ?

	Dave

