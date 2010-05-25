Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab0EYLSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 07:18:37 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56698 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756387Ab0EYLSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 07:18:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=f0EwuQ2DV+o4pBWaVuPbQy73f2DnOhJ9YTwGLlWKcQQlpm9N98F9ZECPCEJWPv1zBB
         v1KMNWMfJI6nB7UXTMwDE6syZ40Yws9Y1ibLZ4ByBeWUKypl5qUGiW5psdapTmJdEtxB
         un9In+xmluQ6RKShgvwoGT4CQBJNv5F/a3Lwg=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1005251200410.28092@pobox.suse.cz>
References: <alpine.LNX.2.00.1005251200410.28092@pobox.suse.cz>
Date: Tue, 25 May 2010 20:18:35 +0900
Message-ID: <AANLkTik-k5lECpQtbsQy8DLJJ3DOPrAz_e5XPPMzgr2o@mail.gmail.com>
Subject: Re: [PATCH] staging: remove all code dependent on LINUX_VERSION_CODE
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/drivers/staging/cxt1e1/hwprobe.c b/drivers/staging/cxt1e1/hwprobe.c
> index 4c86102..c52ff7c 100644
> --- a/drivers/staging/cxt1e1/hwprobe.c
> +++ b/drivers/staging/cxt1e1/hwprobe.c
> @@ -305,15 +305,9 @@ c4hw_attach_all (void)
>     error_flag = 0;
>     prep_hdw_info ();
>     /*** scan PCI bus for all possible boards */
> -#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
> -    while ((pdev = pci_get_device (PCI_VENDOR_ID_CONEXANT,
> -                                   PCI_DEVICE_ID_CN8474,
> -                                   pdev)))
> -#else
>     while ((pdev = pci_find_device (PCI_VENDOR_ID_CONEXANT,
>                                     PCI_DEVICE_ID_CN8474,
>                                     pdev)))
> -#endif
>     {
>         if (c4_hdw_init (pdev, found))
>             found++;

It should be the other way around.
(sorry my previous message crapped)
