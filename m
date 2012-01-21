Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab2AUPvv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 10:51:51 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:20722 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab2AUPvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 10:51:50 -0500
Date: Sat, 21 Jan 2012 18:52:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sam Hansen <solid.se7en@gmail.com>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] xgifb: checkpatch cleanup, printk() KERN_*
Message-ID: <20120121155235.GN3294@mwanda>
References: <1327140612-9694-1-git-send-email-solid.se7en@gmail.com>
 <1327140612-9694-3-git-send-email-solid.se7en@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3rMDlCEgcaHQQFB+"
Content-Disposition: inline
In-Reply-To: <1327140612-9694-3-git-send-email-solid.se7en@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090206.4F1ADF04.005B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3rMDlCEgcaHQQFB+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 21, 2012 at 02:10:12AM -0800, Sam Hansen wrote:
>  	if (reg1 != 0xa1) { /*I/O error */
> -		printk("\nXGIfb: I/O error!!!");
> +		printk(KERN_ERR "\nXGIfb: I/O error!!!");

It doesn't make sense to do this.  KERN_ERR puts a "<3>" in front of
the line so we know how important it is, but it's a blank line
because of the "\n" at the start.

Also the should probably be using pr_err() or dev_err().

> -	printk("XGIfb: XGIInitNew() ...");
> +	printk(KERN_INFO "XGIfb: XGIInitNew() ...");
>  	pci_set_drvdata(pdev, xgifb_info);
>  	if (XGIInitNew(pdev))
> -		printk("OK\n");
> +		printk(KERN_INFO "OK\n");
>  	else
> -		printk("Fail\n");
> +		printk(KERN_ERR "Fail\n");

These put a "<3>" in the middle of the line which doesn't help
anyone.  Rewrite it so it's on one line.  Get rid of the OK line.

>  	if (pVBInfo->FBAddr == NULL) {
> -		printk("\n pVBInfo->FBAddr == 0 ");
> +		printk(KERN_INFO "\n pVBInfo->FBAddr == 0 ");

Same.

regards,
dan carpenter

--3rMDlCEgcaHQQFB+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPGt9CAAoJEOnZkXI/YHqRJ/MP/i/uZs3yuSjqrOI+uSJM/39i
VR7boIrwvSSZ7H4dLLmQ0QobrnrXAI9OsDowoqcaYyxCjFn4a9SFQMpu6VFI4MGy
Lvcw10swoSoSZAUt+KILlr0XSUOPERXA4/bjeDaeErdvfVweKGhFHS0z0CPwb5b1
lw6rzI+mcCZ7eqNHYQU4GZfiHphBJ2d8MPG1JF2+jkVqCO1rMzK/LZEiOZVeiIAV
mjmES5HeAG0inAG6g32i61FGAGagcpbVxJqgA2YpGn6viDvyzXxWJ4NqFVgPYpBp
38oa9RuLxykCjX57QDoGhnfQLe2Mb6x++lGcbfATdf7l6pSnXa87kGR5bICmegki
+0JSamhY4dgo8Gr8hvBJ3McmJ0Y651+4Gp1FGzB0Z9UsiMFdObBiZGWhCRkhtXJ9
uAiFFRhE3YG3BYZTryIlFGi6a8xGL3sqUGAIwNgERq3P5ba/jerMDB4b2+n4RKHx
3NIUE2r9ERYeq/S5bEswE5iHikYGf92nVdsRRMxF2Ubl9tMFfEAVW2rKn/QzR1EY
9rVQHQHjEeCp/0Npdkw+iiqTeRV7jI6WcfX+1hF5SCI/tF2aas6J/QMvMN4ukMuF
NzD+9damydBBSxzmufSSsjLCZbG9NTKbxta3/T5i+tuUEvTHaG0TE1fOVFFQURef
fDuP2rAnMeAZ5T9DX+Di
=b6/b
-----END PGP SIGNATURE-----

--3rMDlCEgcaHQQFB+--
