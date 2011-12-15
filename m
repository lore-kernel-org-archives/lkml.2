Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590Ab1LOCZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 21:25:27 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:49867 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863Ab1LOCZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 21:25:26 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 30/30] Staging: comedi: fix printk issue in jr3_pci.c
In-Reply-To: Your message of "Mon, 12 Dec 2011 12:52:19 +0530."
             <1323674539-19307-1-git-send-email-ravishankar.km@greenturtles.in>
From: Valdis.Kletnieks@vt.edu
References: <1323674539-19307-1-git-send-email-ravishankar.km@greenturtles.in>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1323915917_2907P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 14 Dec 2011 21:25:17 -0500
Message-ID: <12715.1323915917@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020207.4EE95A8F.0010,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1323915917_2907P
Content-Type: text/plain; charset=us-ascii

On Mon, 12 Dec 2011 12:52:19 +0530, Ravishankar karkala Mallikarjunayya said:
> This is a patch to the jr3_pci.c file that fixes up a
> printk warning found by the checkpatch.pl tool.

> diff --git a/drivers/staging/comedi/drivers/jr3_pci.c b/drivers/staging/comedi/drivers/jr3_pci.c
> index 2a97894..6a79ba1 100644
> --- a/drivers/staging/comedi/drivers/jr3_pci.c
> +++ b/drivers/staging/comedi/drivers/jr3_pci.c
> @@ -593,24 +593,24 @@ static struct poll_delay_t jr3_pci_poll_subdevice(struct comedi_subdevice *s)
>  					min_full_scale =
>  					    get_min_full_scales(channel);
>  					printk("Obtained Min. Full Scales:\n");
> -					printk("%i   ", (min_full_scale).fx);
> -					printk("%i   ", (min_full_scale).fy);
> -					printk("%i   ", (min_full_scale).fz);
> -					printk("%i   ", (min_full_scale).mx);
> -					printk("%i   ", (min_full_scale).my);
> -					printk("%i   ", (min_full_scale).mz);
> -					printk("\n");
> +					printk(KERN_DEBUG "%i ", (min_full_scale).fx);
> +					printk(KERN_CONT "%i ", (min_full_scale).fy);
> +					printk(KERN_CONT "%i ", (min_full_scale).fz);
> +					printk(KERN_CONT "%i ", (min_full_scale).mx);
> +					printk(KERN_CONT "%i ", (min_full_scale).my);
> +					printk(KERN_CONT "%i ", (min_full_scale).mz);
> +					printk(KERN_CONT "\n");

Is there a reason that as long as you were fixing this code, you didn't make it
one call to printk?

					printk(KERN_DEBUG,"%i %i %i %i %i %i\n",
						(min_full_scale).fx),
						(min_full_scale).fy),
						(min_full_scale).fz),
						(min_full_scale).mx),
						(min_full_scale).my),
						(min_full_scale).mz));

Doing it this way helps guarantee that another CPU doesn't inject a printk into
the middle and split up your output.

Also, there should be at least a *short* text string in that printk saying what
it is.  printk(KERN_DEBUG,"jr3_poll %i"   or similar would be a start.
Otherwise you get a line with 6 integers in it.

Also, if you're indented that far to the right, that driver is probably in
serious need of some restructuring or refactoring.


--==_Exmh_1323915917_2907P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFO6VqNcC3lWbTT17ARAiH5AKCyhVbRLgSZoMvc8sV/UAjU4UNtBwCgl2qb
Ap+uVeaAL8IRuM2DqJuMw5Q=
=9bL+
-----END PGP SIGNATURE-----

--==_Exmh_1323915917_2907P--

