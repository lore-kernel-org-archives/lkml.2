Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242Ab2AIQCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 11:02:47 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:52912 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932153Ab2AIQCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 11:02:46 -0500
X-Greylist: delayed 581 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Jan 2012 11:02:46 EST
Date: Mon, 9 Jan 2012 10:52:56 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: Re: [PATCH] modules: sysfs - export: taint, address, size
Message-ID: <20120109155256.GA2288@elliptictech.com>
References: <1325951076.860.2.camel@mop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325951076.860.2.camel@mop>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-01-07 16:44 +0100, Kay Sievers wrote:
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: modules: sysfs - export taint, address, size
> 
> Recent tools do not use /proc to retrieve module information. A few values
> are currently missing from sysfs.
[...]
> @@ -907,10 +927,8 @@ static ssize_t show_refcnt(struct module
>  	return sprintf(buffer, "%u\n", module_refcount(mk->mod));
>  }
>  
> -static struct module_attribute refcnt = {
> -	.attr = { .name = "refcnt", .mode = 0444 },
> -	.show = show_refcnt,
> -};
> +static struct module_attribute refcnt =
> +	__ATTR(refcnt, 0444, show_refcnt, NULL);

This change seems unrelated to the patch description, and is not
mentioned in the changelog.  Several instances of this.

[...]
>  static struct module_attribute *modinfo_attrs[] = {
>  	&modinfo_version,
>  	&modinfo_srcversion,
> -	&initstate,
> +	&module_initstate,

Another unrelated change?

>  	&module_uevent,
> +	&module_address,
> +	&module_size,
> +	&module_taint,

You've forgotten to update Documentation/ABI to describe these new
attributes.

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

