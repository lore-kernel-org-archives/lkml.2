Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab2HOWCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 18:02:44 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:27022 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab2HOWCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 18:02:42 -0400
Date: Thu, 16 Aug 2012 00:02:40 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Kent Yoder <key@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        Sirrix AG <tpmdd@sirrix.com>, Marcel Selhorst <tpmdd@selhorst.net>,
        Rajiv Andrade <mail@srajiv.net>, Seiji Munetoh <munetoh@jp.ibm.com>,
        Stefan Berger <stefanb@us.ibm.com>,
        Reiner Sailer <sailer@watson.ibm.com>, Kylene Hall <kjhall@us.ibm.com>
Subject: Re: [PATCH] tpm: Do not dereference NULL pointer if acpi_os_map_memory()
 fails.
In-Reply-To: <20120815201527.GC27618@linux.vnet.ibm.com>
Message-ID: <alpine.LNX.2.00.1208160001080.7818@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1208072247490.3227@swampdragon.chaosbits.net> <20120808180750.GA24016@linux.vnet.ibm.com> <20120815201527.GC27618@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2012, Kent Yoder wrote:

> Hi Jesper,
> 
> > > Unfortunately we just get NULL back, so we can't really tell the user
> > > exactely what went wrong, but we can at least avoid crashing and
> > > return an error (-EIO seemed more generic and more suitable here than
> > > -ENOMEM or something else, so I picked that).
> > 
> > Thanks Jesper. I'd made some updates to tpm_bios.c recently but this
> > should still apply. I'll let you know if not.
> 
>   Of course I'm wrong here, this code moved over into tpm_acpi.c. If you
> can resubmit on top of my staging tree, I will apply it there.
> 

No problem. I'll have that patch for you in a moment when I'm done 
fetching your tree.


> git://github.com/shpedoikal/linux.git v3.6-rc1-tpmdd-staging
> 
> > > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > > ---
> > >  drivers/char/tpm/tpm_bios.c | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > > 
> > >   Compile tested only.
> > > 
> > > diff --git a/drivers/char/tpm/tpm_bios.c b/drivers/char/tpm/tpm_bios.c
> > > index 0636520..0c5c274 100644
> > > --- a/drivers/char/tpm/tpm_bios.c
> > > +++ b/drivers/char/tpm/tpm_bios.c
> > > @@ -410,6 +410,11 @@ static int read_log(struct tpm_bios_log *log)
> > >  	log->bios_event_log_end = log->bios_event_log + len;
> > > 
> > >  	virt = acpi_os_map_memory(start, len);
> > > +	if (!virt) {
> 
>   Also please add kfree(log->bios_event_log); in this error path.
> 
Whoops, of course, will do.


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

