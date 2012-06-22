Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762609Ab2FVQRA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 12:17:00 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:51320 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762513Ab2FVQQ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 12:16:57 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-131.messagelabs.com!1340381786!12238928!40
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Daniel Lawrence <daniel@danielscottlawrence.com>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 22 Jun 2012 11:16:42 -0500
Subject: RE: [PATCH] Staging: comedi: fixed print_k coding style issue in
 acl7225b.c
Thread-Topic: [PATCH] Staging: comedi: fixed print_k coding style issue in
 acl7225b.c
Thread-Index: Ac1QdwQApvz+TvYfSN2Vi799L+3RwAAGu0+g
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698E77457@AUSP01VMBX24.collaborationhost.net>
References: <1340370020-9662-1-git-send-email-daniel@danielscottlawrence.com>
In-Reply-To: <1340370020-9662-1-git-send-email-daniel@danielscottlawrence.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 22, 2012 6:00 AM, Danny Lawrence wrote:
> This is a patch to the acl7225b.c file that fixes up 2 print_k warnings
> found by the checkpatch.pl tool.
>
> Signed-off-by: Daniel Lawrence <daniel@danielscottlawrence.com>
> ---
>  drivers/staging/comedi/drivers/acl7225b.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/acl7225b.c b/drivers/staging/comedi/drivers/acl7225b.c
> index 4e4fc41..5392358 100644
> --- a/drivers/staging/comedi/drivers/acl7225b.c
> +++ b/drivers/staging/comedi/drivers/acl7225b.c
> @@ -72,10 +72,10 @@ static int acl7225b_attach(struct comedi_device *dev,
>  
>  	iobase = it->options[0];
>  	iorange = this_board->io_range;
> -	printk(KERN_INFO "comedi%d: acl7225b: board=%s 0x%04x\n", dev->minor,
> +	pr_info("comedi%d: acl7225b: board=%s 0x%04x\n", dev->minor,
>  	       this_board->name, iobase);
>  	if (!request_region(iobase, iorange, "acl7225b")) {
> -		printk(KERN_ERR "comedi%d: request_region failed - I/O port conflict\n",
> +		pr_err("comedi%d: request_region failed - I/O port conflict\n",
>  			dev->minor);
>  		return -EIO;
>  	}

Fixes to this type of issue in the comedi drivers should change the printk's
to the dev_printk style.

Hint, the format:

dev_info(dev->class_dev, "whatever\n");

Will automatically provide the "comedi%d: " part of the output.

Regards,
Hartley

