Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab1DBLzn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 07:55:43 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62685 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab1DBLzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 07:55:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=q4+AAK54mlX6O/y/Bd3hZ725s+2lU0ytU+vLG5XICLxyeC6+fUu0bl8Kr8mNazy3cj
         EgSDLChQRNu57gPo6C0m4rR5I6Ct3//pqI2d+teF5+Fnu7bgruZjMkQxRbIX76rVFWfh
         Ag1bo55z5Q56tn5CVOsIzIr0gcmzYlNk0ynk8=
MIME-Version: 1.0
In-Reply-To: <20110402100043.GA5890@kamineko.org>
References: <AANLkTi=1xtjEZc2C1=W-v2oYbvvcGH9k_DGGXvJ8=swq@mail.gmail.com>
	<20110401172241.GA26851@srcf.ucam.org>
	<BANLkTikPjwowBge82viT+Ma5UnP0fA-pew@mail.gmail.com>
	<20110402100043.GA5890@kamineko.org>
Date: Sat, 2 Apr 2011 14:55:38 +0300
Message-ID: <BANLkTikVGWM3T1y2XvwkHB+Yub5EhG1RPA@mail.gmail.com>
Subject: Re: Regression 2.6.39-rc1 for sony-laptop
From: Dan Carpenter <error27@gmail.com>
To: Mattia Dongili <malattia@linux.it>
Cc: Andrea Gelmini <andrea.gelmini@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, anssi.hannula@iki.fi,
        linux-acpi@vger.kernel.org, axel.lin@gmail.com, trenn@suse.de,
        len.brown@intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/2/11, Mattia Dongili <malattia@linux.it> wrote:
> --- a/drivers/platform/x86/sony-laptop.c
> +++ b/drivers/platform/x86/sony-laptop.c
> @@ -810,6 +810,11 @@ static int sony_nc_handles_cleanup(struct
> platform_device *pd)
>  static int sony_find_snc_handle(int handle)
>  {
>  	int i;
> +
> +	/* not initialized yet, return early */
> +	if (!handles)
> +		return -1;

-1 is -EPERM.  That's not the right error code here.  Maybe -EINVAL?

regards,
dan carpenter
