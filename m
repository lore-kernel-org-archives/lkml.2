Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab2FGMYD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 08:24:03 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52588 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab2FGMX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 08:23:59 -0400
Message-ID: <4FD09D35.9020505@mvista.com>
Date: Thu, 07 Jun 2012 16:23:17 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Namjae Jeon <linkinjeon@gmail.com>
CC: James.Bottomley@HansenPartnership.com, gregkh@linuxfoundation.org,
        mdharm-usb@one-eyed-alien.net, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH 2/3] usb: storage: add support write cache quirk on usb
 hdd
References: <1338985247-9720-1-git-send-email-linkinjeon@gmail.com>
In-Reply-To: <1338985247-9720-1-git-send-email-linkinjeon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06-06-2012 16:20, Namjae Jeon wrote:

> Add support

    You missed "for" here and in the subject.

> write cache quirk on usb hdd. scsi driver will be set to wce by detecting write cache quirk in quirk list when plugging usb hdd.

> Signed-off-by: Namjae Jeon<namjae.jeon@samsung.com>
> Signed-off-by: Pankaj Kumar<pankaj.km@samsung.com>
> Signed-off-by: Amit Sahrawat<a.sahrawat@samsung.com>
> ---
>   drivers/usb/storage/scsiglue.c |    6 ++++++
>   drivers/usb/storage/usb.c      |    5 ++++-
>   include/linux/usb/quirks.h     |    3 +++
>   include/linux/usb_usual.h      |    4 +++-
>   4 files changed, 16 insertions(+), 2 deletions(-)

> diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
> index a324a5d..f7d0ea5 100644
> --- a/drivers/usb/storage/scsiglue.c
> +++ b/drivers/usb/storage/scsiglue.c
[...]
> @@ -230,6 +231,11 @@ static int slave_configure(struct scsi_device *sdev)
>   					US_FL_SCM_MULT_TARG))&&
>   				us->protocol == USB_PR_BULK)
>   			us->use_last_sector_hacks = 1;
> +
> +		/* Check for the cache quirk present or not */
> +		if (us->pusb_dev->quirks & USB_QUIRK_WRITE_CACHE ||
> +				us->fflags & US_FL_WRITE_CACHE)
> +				sdev->wce_quirk = 1;

    You overindented the last statement, so that it looks a bit like a 
continuation of previous *if*.

WBR, Sergei
