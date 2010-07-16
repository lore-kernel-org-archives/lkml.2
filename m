Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244Ab0GPUMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 16:12:36 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:48994
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753797Ab0GPUMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 16:12:35 -0400
X-SpamScore: -15
X-BigFish: VS-15(zz1432N98dN103dKzz1202hzzz2dh2a8h61h)
X-Spam-TCS-SCL: 0:0
Date: Fri, 16 Jul 2010 15:12:24 -0500
From: Scott Wood <scottwood@freescale.com>
To: Anton Vorontsov <avorontsov@mvista.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Peter Tyser <ptyser@xes-inc.com>, linux-kernel@vger.kernel.org,
        Dave Jiang <djiang@mvista.com>, linuxppc-dev@ozlabs.org,
        Doug Thompson <dougthompson@xmission.com>
Subject: Re: [PATCH v2] edac: mpc85xx: Add support for new MPCxxx/Pxxxx EDAC
 controllers
Message-ID: <20100716151224.21d499a3@schlenkerla.am.freescale.net>
In-Reply-To: <20100715182507.GA3482@oksana.dev.rtsoft.ru>
References: <20100715182507.GA3482@oksana.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jul 2010 20:12:25.0983 (UTC) FILETIME=[356118F0:01CB2523]
X-Reverse-DNS: az33egw02.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jul 2010 22:25:07 +0400
Anton Vorontsov <avorontsov@mvista.com> wrote:

> Simply add proper IDs into the device table.
> 
> Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
> ---
> 
> It appears that the driver has two device ID tables. :-)
> So, my previous attempt enabled only half of the functionality.
> 
> Andrew,
> 
> Can you please replace
> 
>   edac-mpc85xx-add-support-for-mpc8569-edac-controllers.patch
> 
> with this patch? It also adds some more IDs for the newer chips.
> 
> Thanks!
> 
>  drivers/edac/mpc85xx_edac.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
> index 52ca09b..3820879 100644
> --- a/drivers/edac/mpc85xx_edac.c
> +++ b/drivers/edac/mpc85xx_edac.c
> @@ -646,8 +646,12 @@ static struct of_device_id mpc85xx_l2_err_of_match[] = {
>  	{ .compatible = "fsl,mpc8555-l2-cache-controller", },
>  	{ .compatible = "fsl,mpc8560-l2-cache-controller", },
>  	{ .compatible = "fsl,mpc8568-l2-cache-controller", },
> +	{ .compatible = "fsl,mpc8569-l2-cache-controller", },
>  	{ .compatible = "fsl,mpc8572-l2-cache-controller", },
> +	{ .compatible = "fsl,p1020-l2-cache-controller", },
> +	{ .compatible = "fsl,p1021-l2-cache-controller", },
>  	{ .compatible = "fsl,p2020-l2-cache-controller", },
> +	{ .compatible = "fsl,p4080-l2-cache-controller", },

L2 on the p4080 is quite different from those other chips.  It's part
of the core, controlled by SPRs.

-Scott

