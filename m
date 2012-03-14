Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030182Ab2CNIRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 04:17:48 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:17985 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab2CNIRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 04:17:45 -0400
Date: Wed, 14 Mar 2012 11:19:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Julia Lawall <julia.lawall@lip6.fr>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] arch/unicore32/kernel/dma.c: ensure arguments to
 request_irq and free_irq are compatible
Message-ID: <20120314081910.GC3163@mwanda>
References: <1331494587-12196-1-git-send-email-Julia.Lawall@lip6.fr>
 <1331494587-12196-8-git-send-email-Julia.Lawall@lip6.fr>
 <1331513926.2048.58.camel@epip-laptop>
 <alpine.DEB.2.02.1203120625570.2066@localhost6.localdomain6>
 <1331622633.2048.87.camel@epip-laptop>
 <alpine.DEB.2.02.1203130921250.1974@localhost6.localdomain6>
 <1331712444.2389.36.camel@epip-laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lCAWRPmW1mITcIfM"
Content-Disposition: inline
In-Reply-To: <1331712444.2389.36.camel@epip-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4F6053F7.00D1,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lCAWRPmW1mITcIfM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 14, 2012 at 04:07:24PM +0800, Guan Xuetao wrote:
> puv3_init_dma() is called ONCE when initializing.
> In logical, if request_irq(IRQ_DMAERR, *) failed, free_irq(IRQ_DMA, *)
> is unnecessary, and dma device/driver can keep on working.
> The patch could be:
>   	ret = request_irq(IRQ_DMAERR, dma_err_handler, 0, "DMAERR", NULL);
>   	if (ret) {
>   		printk(KERN_CRIT "Can't register IRQ for DMAERR\n");
>  -		free_irq(IRQ_DMA, "DMA");
>   		return ret;
>   	}

It seems like you should remove the error return as well?

regards,
dan carpenter


--lCAWRPmW1mITcIfM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPYFR+AAoJEOnZkXI/YHqRvWQP/i6s9o7enfw/EwsnK3ek2yR/
Pi1gyNCcxWvAyzEOis/KiW+qzy2KRbXIMvf0r+vHD6/Aq9o/W7YIjOu6HluBZtsa
ffLDFx4UpVXsiFeGcivnB3Ae5EBAS20K+Z1HwLDGyNfFnK+hl4F0upPqF+/1aFYs
pAiToS3WUWv7sI5d5Zi+Ck/Bh9dlfLoOfq+T75UMJptn/2AIJwEHVGCBr908vbD3
BT4ac7wrxnf22g580wSkr44wJcZR5lTUwJAuPbOEqbXkM3UFZbzPtaSofr1Z8lEb
jI3Am7nmNnSwsbzGEbtKCXhm9bzvHfrGpBOjPuWbm37SsFtSH0YQ2/H/wnCuHOxi
ZyoWXkjyOkOGzDwnuFr9ekYMrqK+x9EMMl927ZwLKQ5DJXrmYPTIKu/c0S+hk2Z/
nrfVfkeRT2AUbm33177s8DXCgjnCZi5nkBLMGh5/ZCpORGKeAPlh4ZhZkzmRIuoh
L2aKnv9JvlROAiqiOAjJ3Eji6Gj+GkVoqBU6/EJQurypCmyT3TbDh5WuSH1U7rKe
FfwWGvb/4x3HDEdTs61l8aN02vDVRFgEWm9uQhNR6nMca1vnf6cWs2itvXaM1bYB
eYQc3vYjSQ9WEsnvVdA+bHTFfedlRj6udMuuWG/EgvTzsVbrMnX7v11syC8KOnD0
vrxctvknmhwW3VDQXlDi
=1HYn
-----END PGP SIGNATURE-----

--lCAWRPmW1mITcIfM--
