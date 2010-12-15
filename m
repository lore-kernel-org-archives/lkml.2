Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab0LOBgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 20:36:36 -0500
Received: from 29.mail-out.ovh.net ([87.98.216.213]:52904 "HELO
	29.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752106Ab0LOBgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 20:36:35 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Dec 2010 20:36:35 EST
Date: Wed, 15 Dec 2010 02:25:11 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Patrice VILCHEZ <patrice.vilchez@atmel.com>
Subject: Re: [PATCH] base: add sysfs socs info
Message-ID: <20101215012511.GQ19897@game.jcrosoft.org>
References: <1292330417-13703-1-git-send-email-plagnioj@jcrosoft.com>
 <20101214161130.GB1857@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101214161130.GB1857@suse.de>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 1877719569764625296
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08:11 Tue 14 Dec     , Greg KH wrote:
> On Tue, Dec 14, 2010 at 01:40:17PM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > this provide an easy way to register soc information
> > 
> > arch, family, model, id, revision
> > 
> > as this for at91sam9g20
> > 
> > $ cat /sys/devices/system/soc/soc0/arch
> > current
> > $ cat /sys/devices/system/soc/soc0/family
> > at91
> > $ cat /sys/devices/system/soc/soc0/id
> > at91sam9g20
> > $ cat /sys/devices/system/soc/soc0/model
> > 0x00000000019905a0
> > $ cat /sys/devices/system/soc/soc0/revision
> > 1.1
> 
> What is this for?  When you add sysfs files, you are required to add
> entries to the Documentation/ABI/ files as well, please always provide
> this so we are able to review the code easier.
I'll add a doc in Documentation/ABI
 
> > +struct soc {
> > +	u64 id;
> > +	char *arch;
> > +	char *family;
> > +	char *model;
> > +	char *revision;
> > +	struct sys_device sysdev;
> > +};
> 
> What is a "SOC"?  A "Small Ordinary Creature"?
:) Systen On Chip
> 
> And does every system have one of these?  Just one?  Not multiple?  We
> need a whole lot more information here as to why this code is needed,
> and who will be using it.
> 
> Also, isn't this information already in /proc/cpu/ today?
no all this information are not present in /proc/cpu and a cpu is not a soc

basicaly on a board you will have one soc but some boards have more as example
some ST boards you have two sh4 soc or on some amcc you have two powerpc soc

with these information you are allow to dynamise the userspace based on the
soc or the companion soc and also be able to display this information in a UI

Best Regards,
J.
