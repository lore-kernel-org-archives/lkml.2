Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094Ab2JIWyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 18:54:38 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:39441 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756776Ab2JIWyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 18:54:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Igor Murzov <e-mail@date.by>
Cc: linux-acpi@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Len Brown <lenb@kernel.org>, Sergey V <sftp.mtuci@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI video: Ignore AE_AML_PACKAGE_LIMIT errors after _DOD evaluation.
Date: Wed, 10 Oct 2012 00:58:10 +0200
Message-ID: <1357974.cUcUJdG05H@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.0-2.10-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1349821146-19155-1-git-send-email-e-mail@date.by>
References: <1349821146-19155-1-git-send-email-e-mail@date.by>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 of October 2012 02:19:06 Igor Murzov wrote:
> This should fix brightness controls on some laptops.
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=47861
> 
> Signed-off-by: Igor Murzov <e-mail@date.by>

Put more detials into the changelog, please.  The BZ entry linked above
may or may not be accessible when the changelog is read by someone.

> ---
>  drivers/acpi/video.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> index 1e0a9e1..01bb58d 100644
> --- a/drivers/acpi/video.c
> +++ b/drivers/acpi/video.c
> @@ -1349,8 +1349,12 @@ acpi_video_bus_get_devices(struct acpi_video_bus *video,
>  	struct acpi_device *dev;
>  
>  	status = acpi_video_device_enumerate(video);
> -	if (status)
> -		return status;
> +	if (status) {
> +		if (status == AE_AML_PACKAGE_LIMIT)
> +			status = 0; /* Ignore this error */
> +		else
> +			return status;
> +	}

First off, please add a comment explaining _why_ we're ignoring the error.

Second, what about adding just:

if (status == AE_AML_PACKAGE_LIMIT)
	status = 0;

before the "if (status)" check?

>  
>  	list_for_each_entry(dev, &device->children, node) {

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
