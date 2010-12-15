Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321Ab0LODqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 22:46:35 -0500
Received: from cantor.suse.de ([195.135.220.2]:51218 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198Ab0LODqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 22:46:34 -0500
Date: Tue, 14 Dec 2010 19:47:13 -0800
From: Greg KH <gregkh@suse.de>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Patrice VILCHEZ <patrice.vilchez@atmel.com>
Subject: Re: [PATCH] base: add sysfs socs info
Message-ID: <20101215034713.GB3297@suse.de>
References: <1292330417-13703-1-git-send-email-plagnioj@jcrosoft.com>
 <20101214161130.GB1857@suse.de>
 <20101215012511.GQ19897@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101215012511.GQ19897@game.jcrosoft.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 02:25:11AM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 08:11 Tue 14 Dec     , Greg KH wrote:
> > On Tue, Dec 14, 2010 at 01:40:17PM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > > this provide an easy way to register soc information
> > > 
> > > arch, family, model, id, revision
> > > 
> > > as this for at91sam9g20
> > > 
> > > $ cat /sys/devices/system/soc/soc0/arch
> > > current
> > > $ cat /sys/devices/system/soc/soc0/family
> > > at91
> > > $ cat /sys/devices/system/soc/soc0/id
> > > at91sam9g20
> > > $ cat /sys/devices/system/soc/soc0/model
> > > 0x00000000019905a0
> > > $ cat /sys/devices/system/soc/soc0/revision
> > > 1.1
> > 
> > What is this for?  When you add sysfs files, you are required to add
> > entries to the Documentation/ABI/ files as well, please always provide
> > this so we are able to review the code easier.
> I'll add a doc in Documentation/ABI
>  
> > > +struct soc {
> > > +	u64 id;
> > > +	char *arch;
> > > +	char *family;
> > > +	char *model;
> > > +	char *revision;
> > > +	struct sys_device sysdev;
> > > +};
> > 
> > What is a "SOC"?  A "Small Ordinary Creature"?
> :) Systen On Chip
> > 
> > And does every system have one of these?  Just one?  Not multiple?  We
> > need a whole lot more information here as to why this code is needed,
> > and who will be using it.
> > 
> > Also, isn't this information already in /proc/cpu/ today?
> no all this information are not present in /proc/cpu and a cpu is not a soc
> 
> basicaly on a board you will have one soc but some boards have more as example
> some ST boards you have two sh4 soc or on some amcc you have two powerpc soc
> 
> with these information you are allow to dynamise the userspace based on the
> soc or the companion soc and also be able to display this information in a UI

Ok, but then why not make it "real" devices and not sysdev?  We are
trying to fix the sysdev code to be semi-real devices, so you might as
well make them real ones now.

thanks,

greg k-h
