Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558Ab2GSTxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 15:53:36 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:32671 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab2GSTxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 15:53:33 -0400
Date: Thu, 19 Jul 2012 15:44:46 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 06/17] xen-blkfront: remove IRQF_SAMPLE_RANDOM which is
 now a no-op
Message-ID: <20120719194446.GA17097@phenom.dumpdata.com>
References: <1342560756-18737-1-git-send-email-tytso@mit.edu>
 <1342560756-18737-7-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342560756-18737-7-git-send-email-tytso@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 05:32:25PM -0400, Theodore Ts'o wrote:
> With the changes in the random tree, IRQF_SAMPLE_RANDOM is now a
> no-op; interrupt randomness is now collected unconditionally in a very
> low-overhead fashion; see commit 775f4b297b.  The IRQF_SAMPLE_RANDOM
> flag was scheduled to be removed in 2009 on the
> feature-removal-schedule, so this patch is preparation for the final
> removal of this flag.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> ---
>  drivers/block/xen-blkfront.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 60eed4b..8f7a071 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -854,9 +854,8 @@ static int setup_blkring(struct xenbus_device *dev,
>  	if (err)
>  		goto fail;
>  
> -	err = bind_evtchn_to_irqhandler(info->evtchn,
> -					blkif_interrupt,
> -					IRQF_SAMPLE_RANDOM, "blkif", info);
> +	err = bind_evtchn_to_irqhandler(info->evtchn, blkif_interrupt, 0,
> +					"blkif", info);
>  	if (err <= 0) {
>  		xenbus_dev_fatal(dev, err,
>  				 "bind_evtchn_to_irqhandler failed");
> -- 
> 1.7.11.1.108.gb129051
