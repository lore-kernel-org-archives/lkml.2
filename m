Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455Ab0GGAaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 20:30:06 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:47150 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755953Ab0GGAaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 20:30:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lAyalk0a7/z0Ws/hvburQTNsp36Q+88tGaKa6n6bj6OwEQ0a9hfqSrQQy1Fge25bRa
         qJISzS06LpYitFdVwxnGxZLtrquVVLhFFpnicpJw8CBhpDMVFKpxs27/wzfvYISDvWIZ
         NC5oWltyBFnwYEjIcq8uH+S+Ghfskf9RAalKk=
Date: Tue, 6 Jul 2010 17:29:52 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Harald Welte <laforge@gnumonks.org>, Matthew Garrett <mjg@redhat.com>,
       Richard Purdie <rpurdie@linux.intel.com>,
       =?iso-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
       Jiri Kosina <jkosina@suse.cz>, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH v2] panasonic-laptop: fix acpi_pcc_write_sset return value
Message-ID: <20100707002952.GA7035@core.coreip.homeip.net>
References: <1278462108.12801.23.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278462108.12801.23.camel@mola>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 08:21:48AM +0800, Axel Lin wrote:
> In current implementation, acpi_pcc_write_sset return 1
> if write is successful, 0 if write is failed.
> But all the callers consider acpi_pcc_write_sset return 0
> if write is successful and return negtive if write is failed.
> 
> This patch changes the implementation of acpi_pcc_write_sset to
> return 0 if write is successful, -EIO if write is failed.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/platform/x86/panasonic-laptop.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/platform/x86/panasonic-laptop.c b/drivers/platform/x86/panasonic-laptop.c
> index 2fb9a32..ec01c3d 100644
> --- a/drivers/platform/x86/panasonic-laptop.c
> +++ b/drivers/platform/x86/panasonic-laptop.c
> @@ -248,7 +248,7 @@ static int acpi_pcc_write_sset(struct pcc_acpi *pcc, int func, int val)
>  	status = acpi_evaluate_object(pcc->handle, METHOD_HKEY_SSET,
>  				      &params, NULL);
>  
> -	return status == AE_OK;
> +	return (status == AE_OK) ? 0 : -EIO;
>  }
>  
>  static inline int acpi_pcc_get_sqty(struct acpi_device *device)
> @@ -586,7 +586,6 @@ static int acpi_pcc_init_input(struct pcc_acpi *pcc)
>  static int acpi_pcc_hotkey_resume(struct acpi_device *device)
>  {
>  	struct pcc_acpi *pcc = acpi_driver_data(device);
> -	acpi_status status = AE_OK;
>  
>  	if (device == NULL || pcc == NULL)
>  		return -EINVAL;

Looks good, but why don't you also kill these useless checks while you
are at it?  Otherwise:

Acked-by: Dmitry Torokhov <dtor@mail.ru>

Thanks.

-- 
Dmitry
