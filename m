Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab2CLL71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 07:59:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:25143 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393Ab2CLL7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 07:59:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="76388151"
Subject: Re: [PATCH] libata: disable runtime pm for hotpluggable port
From: Lin Ming <ming.m.lin@intel.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, jslaby@suse.cz, cwillu@cwillu.com,
        jackdachef@gmail.com
In-Reply-To: <4F5DD01D.3010609@mvista.com>
References: <1331515012.3412.37.camel@minggr>  <4F5DD01D.3010609@mvista.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 12 Mar 2012 19:59:08 +0800
Message-ID: <1331553548.3102.1.camel@hp6530s>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-12 at 14:29 +0400, Sergei Shtylyov wrote:
> Hello.
> 
> On 12-03-2012 5:16, Lin Ming wrote:
> 
> > Currently, hotplug doesn't work if port is already runtime suspended.
> > For now, we simply disable runtime pm for hotpluggable port.
> > Later, we should add runtime pm support for hotpluggable port too.
> 
> > https://lkml.org/lkml/2012/2/19/70
> 
> > TODO: add similar hotpluggable port check for controllers other than AHCI.
> 
> > Reported-and-tested-by: Jiri Slaby<jslaby@suse.cz>
> > Reported-and-tested-by: cwillu@cwillu.com
> > Reported-and-tested-by: jackdachef@gmail.com
> > Signed-off-by: Lin Ming<ming.m.lin@intel.com>
> [...]
> 
> > diff --git a/include/linux/libata.h b/include/linux/libata.h
> > index 3085bdc..ccf0282 100644
> > --- a/include/linux/libata.h
> > +++ b/include/linux/libata.h
> > @@ -209,8 +209,10 @@ enum {
> >   	ATA_FLAG_SW_ACTIVITY	= (1<<  22), /* driver supports sw activity
> >   					      * led */
> >   	ATA_FLAG_NO_DIPM	= (1<<  23), /* host not happy with DIPM */
> > +	ATA_FLAG_EXTERNAL	= (1<<  24), /* controller supports external SATA */
> > +	ATA_FLAG_PLUGGABLE	= (1<<  25), /* port is hotpluggable */
> >
> > -	/* bits 24:31 of ap->flags are reserved for LLD specific flags */
> > +	/* bits 26:31 of ap->flags are reserved for LLD specific flags */
> 
>     There's no need to use bits 24..25, I've freed up some lower order bits 
> last year, removing unused values.

OK. I'll use bit 2 and 3, as below

diff --git a/include/linux/libata.h b/include/linux/libata.h
index cafc09a..f46961d 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -187,6 +187,8 @@ enum {
 	ATA_FLAG_SLAVE_POSS	= (1 << 0), /* host supports slave dev */
 					    /* (doesn't imply presence) */
 	ATA_FLAG_SATA		= (1 << 1),
+	ATA_FLAG_EXTERNAL	= (1 << 2), /* Controller supports external SATA */
+	ATA_FLAG_PLUGGABLE	= (1 << 3), /* Port is hotpluggable */
 	ATA_FLAG_NO_ATAPI	= (1 << 6), /* No ATAPI support */
 	ATA_FLAG_PIO_DMA	= (1 << 7), /* PIO cmds via DMA */
 	ATA_FLAG_PIO_LBA48	= (1 << 8), /* Host DMA engine is LBA28 only */


> 
> WBR, Sergei


