Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758958Ab0GUWjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 18:39:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753020Ab0GUWjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 18:39:43 -0400
Date: Wed, 21 Jul 2010 15:39:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Scott Wood <scottwood@freescale.com>
Cc: Anton Vorontsov <avorontsov@mvista.com>, Peter Tyser <ptyser@xes-inc.com>,
        linux-kernel@vger.kernel.org, Dave Jiang <djiang@mvista.com>,
        linuxppc-dev@ozlabs.org, Doug Thompson <dougthompson@xmission.com>
Subject: Re: [PATCH v2] edac: mpc85xx: Add support for new MPCxxx/Pxxxx EDAC
 controllers
Message-Id: <20100721153933.64d02086.akpm@linux-foundation.org>
In-Reply-To: <20100716151224.21d499a3@schlenkerla.am.freescale.net>
References: <20100715182507.GA3482@oksana.dev.rtsoft.ru>
	<20100716151224.21d499a3@schlenkerla.am.freescale.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jul 2010 15:12:24 -0500
Scott Wood <scottwood@freescale.com> wrote:

> On Thu, 15 Jul 2010 22:25:07 +0400
> Anton Vorontsov <avorontsov@mvista.com> wrote:
> 
> > Simply add proper IDs into the device table.
> > 
> > Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
> > ---
> > 
> > It appears that the driver has two device ID tables. :-)
> > So, my previous attempt enabled only half of the functionality.
> > 
> > Andrew,
> > 
> > Can you please replace
> > 
> >   edac-mpc85xx-add-support-for-mpc8569-edac-controllers.patch
> > 
> > with this patch? It also adds some more IDs for the newer chips.
> > 

edac-mpc85xx-add-support-for-mpc8569-edac-controllers.patch already got
itself merged.  I queued this:

--- a/drivers/edac/mpc85xx_edac.c~edac-mpc85xx-add-support-for-new-mpcxxx-pxxxx-edac-controllers
+++ a/drivers/edac/mpc85xx_edac.c
@@ -646,8 +646,12 @@ static struct of_device_id mpc85xx_l2_er
 	{ .compatible = "fsl,mpc8555-l2-cache-controller", },
 	{ .compatible = "fsl,mpc8560-l2-cache-controller", },
 	{ .compatible = "fsl,mpc8568-l2-cache-controller", },
+	{ .compatible = "fsl,mpc8569-l2-cache-controller", },
 	{ .compatible = "fsl,mpc8572-l2-cache-controller", },
+	{ .compatible = "fsl,p1020-l2-cache-controller", },
+	{ .compatible = "fsl,p1021-l2-cache-controller", },
 	{ .compatible = "fsl,p2020-l2-cache-controller", },
+	{ .compatible = "fsl,p4080-l2-cache-controller", },
 	{},
 };
 
@@ -1123,7 +1127,10 @@ static struct of_device_id mpc85xx_mc_er
 	{ .compatible = "fsl,mpc8569-memory-controller", },
 	{ .compatible = "fsl,mpc8572-memory-controller", },
 	{ .compatible = "fsl,mpc8349-memory-controller", },
+	{ .compatible = "fsl,p1020-memory-controller", },
+	{ .compatible = "fsl,p1021-memory-controller", },
 	{ .compatible = "fsl,p2020-memory-controller", },
+	{ .compatible = "fsl,p4080-memory-controller", },
 	{},
 };
 
_


> > 
> >  drivers/edac/mpc85xx_edac.c |    8 ++++++++
> >  1 files changed, 8 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
> > index 52ca09b..3820879 100644
> > --- a/drivers/edac/mpc85xx_edac.c
> > +++ b/drivers/edac/mpc85xx_edac.c
> > @@ -646,8 +646,12 @@ static struct of_device_id mpc85xx_l2_err_of_match[] = {
> >  	{ .compatible = "fsl,mpc8555-l2-cache-controller", },
> >  	{ .compatible = "fsl,mpc8560-l2-cache-controller", },
> >  	{ .compatible = "fsl,mpc8568-l2-cache-controller", },
> > +	{ .compatible = "fsl,mpc8569-l2-cache-controller", },
> >  	{ .compatible = "fsl,mpc8572-l2-cache-controller", },
> > +	{ .compatible = "fsl,p1020-l2-cache-controller", },
> > +	{ .compatible = "fsl,p1021-l2-cache-controller", },
> >  	{ .compatible = "fsl,p2020-l2-cache-controller", },
> > +	{ .compatible = "fsl,p4080-l2-cache-controller", },
> 
> L2 on the p4080 is quite different from those other chips.  It's part
> of the core, controlled by SPRs.

erm, was that an ack or a nack?

