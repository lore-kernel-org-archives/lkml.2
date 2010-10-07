Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653Ab0JGEFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 00:05:09 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:36538 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab0JGEFG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 00:05:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=idPSjz+IcUsQ9PT9ChT4ApinoNt6H7MFeTeygSswfCjC+8VQzacHhqoRB1PsztCgCu
         StE6MjnzLDynh9GMIIMT9lR4/m4q7zzQJROjARcWI/UQh/NHEZ1XlRU/yMLw8lu9cTMU
         VT14VfXqc0fMEJ6D7U5t8B603U2I3bOFS1VSc=
MIME-Version: 1.0
In-Reply-To: <1286424072-2819-1-git-send-email-rahul.ruikar@gmail.com>
References: <1286424072-2819-1-git-send-email-rahul.ruikar@gmail.com>
From: Rahul Ruikar <rahul.ruikar@gmail.com>
Date: Thu, 7 Oct 2010 09:33:03 +0530
Message-ID: <AANLkTik9BG4cC82M3Uj-Gniepfnav1P4BwmG0jMPH71k@mail.gmail.com>
Subject: Re: [PATCH] usb: core: endpoint: Fix error path
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rahul Ruikar <rahul.ruikar@gmail.com>, Tejun Heo <tj@kernel.org>,
        asanchez@neurowork.net, rjw@sisk.pl, csanchez@neurowork.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

Kindly include this patch.

- Rahul Ruikar





On 7 October 2010 09:31, Rahul Ruikar <rahul.ruikar@gmail.com> wrote:
> In function usb_create_ep_devs()
> call put_device() when device_register() fails.
>
> Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
> ---
>  drivers/usb/core/endpoint.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/usb/core/endpoint.c b/drivers/usb/core/endpoint.c
> index 3788e73..9da2505 100644
> --- a/drivers/usb/core/endpoint.c
> +++ b/drivers/usb/core/endpoint.c
> @@ -202,7 +202,7 @@ int usb_create_ep_devs(struct device *parent,
>        return retval;
>
>  error_register:
> -       kfree(ep_dev);
> +       put_device(&ep_dev->dev);
>  exit:
>        return retval;
>  }
> --
> 1.7.2.3
>
>
