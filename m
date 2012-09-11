Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab2IKIsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 04:48:15 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:45265 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab2IKIsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 04:48:12 -0400
Date: Tue, 11 Sep 2012 11:47:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Samuel Iglesias =?iso-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Jens Taprogge <jens.taprogge@taprogge.org>,
        linux-kernel@vger.kernel.org, industrypack-devel@lists.sourceforge.net
Subject: Re: [PATCH 04/20] Staging: ipack: Obtain supported speeds from ID
 ROM.
Message-ID: <20120911084727.GN19396@mwanda>
References: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
 <1347267118-9580-4-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1347267118-9580-4-git-send-email-siglesias@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 10:51:42AM +0200, Samuel Iglesias Gonsálvez wrote:
> From: Jens Taprogge <jens.taprogge@taprogge.org>
> 
> Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
> Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
> ---
>  drivers/staging/ipack/ipack.c |    6 ++++++
>  drivers/staging/ipack/ipack.h |    2 ++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/drivers/staging/ipack/ipack.c b/drivers/staging/ipack/ipack.c
> index b3736c0..521ff55 100644
> --- a/drivers/staging/ipack/ipack.c
> +++ b/drivers/staging/ipack/ipack.c
> @@ -261,15 +261,21 @@ static void ipack_parse_id1(struct ipack_device *dev)
>  
>  	dev->id_vendor = id[4];
>  	dev->id_device = id[5];
> +	dev->speed_8mhz = 1;
> +	dev->speed_32mhz = (id[7] == 'H');
>  }
>  
>  static void ipack_parse_id2(struct ipack_device *dev)
>  {
>  	__be16 *id = (__be16 *) dev->id;
> +	u16 flags;
>  
>  	dev->id_vendor = ((be16_to_cpu(id[3]) & 0xff) << 16)
>  			 + be16_to_cpu(id[4]);
>  	dev->id_device = be16_to_cpu(id[5]);
> +	flags = be16_to_cpu(id[10]);
> +	dev->speed_8mhz = ((flags & 2) != 0);
> +	dev->speed_32mhz = ((flags & 4) != 0);

I really dislike "!= 0" double negatives.  I would prefer this:

	dev->speed_8mhz = !!(flags & 2);
	dev->speed_32mhz = !!(flags & 4);

For me the !! is idiomatic and means turn this into a bool.  I don't
know if maybe I'm the only person who feels this way.

regards,
dan carpenter

