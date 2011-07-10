Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab1GJDcu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 23:32:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65302 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab1GJDct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 23:32:49 -0400
Date: Sat, 9 Jul 2011 20:32:43 -0700
From: Phil Oester <kernel@linuxace.com>
To: Narendra_K@Dell.com
Cc: linux-kernel@vger.kernel.org, Jordan_Hargrave@Dell.com,
        jbarnes@virtuousgeek.org
Subject: Re: [PATCH] Fix embedded nic order on Dell PowerEdge systems
Message-ID: <20110710033243.GA12541@linuxace.com>
References: <1307564053-2996-1-git-send-email-kernel@linuxace.com>
 <E31FB011129F30488D5861F3839049151DA349A086@BLRX7MCDC201.AMER.DELL.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E31FB011129F30488D5861F3839049151DA349A086@BLRX7MCDC201.AMER.DELL.COM>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 01:03:00AM -0700, Narendra_K@Dell.com wrote:
> > -----Original Message-----
> > From: Phil Oester [mailto:kernel@linuxace.com]
> > Sent: Thursday, June 09, 2011 1:44 AM
> > To: linux-kernel@vger.kernel.org
> > Cc: K, Narendra; Hargrave, Jordan; jbarnes@virtuousgeek.org
> > Subject: [PATCH] Fix embedded nic order on Dell PowerEdge systems
> > 
> >     In commit 6e8af08dfa40b747002207d3ce8e8b43a050d99f ("PCI: enable
> > pci=bfsort
> >     by default on future Dell systems"), the callback added was placed at the
> >     top of the list, before the specific PowerEdge models.  This ends up
> >     breaking the more specific models listed, since the new callback handles
> >     all Dell systems but the older systems don't have the new 0xB1 smbios
> >     entry.
> > 
> >     Fix this by placing the new check _after_ the more specific PowerEdge
> >     sytems.
> > 
> >     Phil Oester
> > 
> >     Signed-off-by: Phil Oester <kernel@linuxace.com>
> > 
> > diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c index
> > 5fe7502..92df322 100644
> > --- a/arch/x86/pci/common.c
> > +++ b/arch/x86/pci/common.c
> > @@ -247,13 +247,6 @@ static const struct dmi_system_id __devinitconst
> > pciprobe_dmi_table[] = {
> >  	},
> >  #endif		/* __i386__ */
> >  	{
> > -		.callback = find_sort_method,
> > -		.ident = "Dell System",
> > -		.matches = {
> > -			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
> > -		},
> > -	},
> > -	{
> >  		.callback = set_bf_sort,
> >  		.ident = "Dell PowerEdge 1950",
> >  		.matches = {
> > @@ -294,6 +287,13 @@ static const struct dmi_system_id __devinitconst
> > pciprobe_dmi_table[] = {
> >  		},
> >  	},
> >  	{
> > +		.callback = find_sort_method,
> > +		.ident = "Dell System",
> > +		.matches = {
> > +			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
> > +		},
> > +	},
> > +	{
> >  		.callback = set_bf_sort,
> >  		.ident = "HP ProLiant BL20p G3",
> >  		.matches = {
> [>] 
> 
> Hi, this issue is fixed and the fix is in Jesse's linux-next tree.
> 
> http://marc.info/?l=linux-pci&m=130108034729082 (x86/PCI: Preserve existing pci=bfsort whitelist for Dell systems)
> 
> With regards,
> Narendra K

This patch is still not included in 3.0.0-rc6, nor in any stable series.
Some reason for this?  And did Dell do any testing at all on existing
hardware before submitting 6e8af08dfa4?  Seems even a minor amount of
testing should have shown this regression.

Given 3.0.0 is expected soon, perhaps this can be included?  Jesse?

Phil
