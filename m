Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956Ab0GUXgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 19:36:48 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:54185
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755137Ab0GUXgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 19:36:46 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Jul 2010 19:36:46 EDT
X-SpamScore: -12
X-BigFish: VS-12(zz1432N98dNzz1202hzzz2dh2a8h61h)
X-Spam-TCS-SCL: 0:0
Date: Wed, 21 Jul 2010 18:21:08 -0500
From: Scott Wood <scottwood@freescale.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Anton Vorontsov <avorontsov@mvista.com>, Peter Tyser <ptyser@xes-inc.com>,
        linux-kernel@vger.kernel.org, Dave Jiang <djiang@mvista.com>,
        linuxppc-dev@ozlabs.org, Doug Thompson <dougthompson@xmission.com>
Subject: Re: [PATCH v2] edac: mpc85xx: Add support for new MPCxxx/Pxxxx EDAC
 controllers
Message-ID: <20100721182108.5a22c822@schlenkerla.am.freescale.net>
In-Reply-To: <20100721153933.64d02086.akpm@linux-foundation.org>
References: <20100715182507.GA3482@oksana.dev.rtsoft.ru>
	<20100716151224.21d499a3@schlenkerla.am.freescale.net>
	<20100721153933.64d02086.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Jul 2010 23:21:10.0350 (UTC) FILETIME=[674B1EE0:01CB292B]
X-Reverse-DNS: az33egw02.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jul 2010 15:39:33 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 16 Jul 2010 15:12:24 -0500
> Scott Wood <scottwood@freescale.com> wrote:
> 
> > > 
> > >  drivers/edac/mpc85xx_edac.c |    8 ++++++++
> > >  1 files changed, 8 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
> > > index 52ca09b..3820879 100644
> > > --- a/drivers/edac/mpc85xx_edac.c
> > > +++ b/drivers/edac/mpc85xx_edac.c
> > > @@ -646,8 +646,12 @@ static struct of_device_id mpc85xx_l2_err_of_match[] = {
> > >  	{ .compatible = "fsl,mpc8555-l2-cache-controller", },
> > >  	{ .compatible = "fsl,mpc8560-l2-cache-controller", },
> > >  	{ .compatible = "fsl,mpc8568-l2-cache-controller", },
> > > +	{ .compatible = "fsl,mpc8569-l2-cache-controller", },
> > >  	{ .compatible = "fsl,mpc8572-l2-cache-controller", },
> > > +	{ .compatible = "fsl,p1020-l2-cache-controller", },
> > > +	{ .compatible = "fsl,p1021-l2-cache-controller", },
> > >  	{ .compatible = "fsl,p2020-l2-cache-controller", },
> > > +	{ .compatible = "fsl,p4080-l2-cache-controller", },
> > 
> > L2 on the p4080 is quite different from those other chips.  It's part
> > of the core, controlled by SPRs.
> 
> erm, was that an ack or a nack?

NACK, p4080 doesn't belong in this table, at least not its L2.

L3 on p4080 is similar to L2 on these other chips, though, and it
wouldn't take much to get this driver working on it -- but the match
table entry should wait until the differences are accommodated.

-Scott

