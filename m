Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab2F2MVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 08:21:39 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51625 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab2F2MVh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 08:21:37 -0400
MIME-Version: 1.0
In-Reply-To: <1340164055-1062-1-git-send-email-alex.hung@canonical.com>
References: <1340164055-1062-1-git-send-email-alex.hung@canonical.com>
Date: Fri, 29 Jun 2012 14:21:35 +0200
X-Google-Sender-Auth: Flu87gIpHSsk9fX8BR_u4Gqp4fY
Message-ID: <CAHR064jYsmaoSBGACY9u_EZmHfGekgtaOioT_caXUH2XgiJyAQ@mail.gmail.com>
Subject: Re: [PATCH] asus-wmi: use ASUS_WMI_METHODID_DSTS2 as default DSTS ID.
From: Corentin Chary <corentincj@iksaif.net>
To: mjg@redhat.com
Cc: Alex Hung <alex.hung@canonical.com>, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 5:47 AM, Alex Hung <alex.hung@canonical.com> wrote:
> According to responses from the BIOS team, ASUS_WMI_METHODID_DSTS2
> (0x53545344) will be used as future DSTS ID. In addition, calling
> asus_wmi_evaluate_method(ASUS_WMI_METHODID_DSTS2, 0, 0, NULL) returns
> ASUS_WMI_UNSUPPORTED_METHOD in new ASUS laptop PCs. This patch fixes
> no DSTS ID will be assigned in this case.
>
> Signed-off-by: Alex Hung <alex.hung@canonical.com>
> ---
>  drivers/platform/x86/asus-wmi.c |    7 +------
>  1 files changed, 1 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
> index 25e3093..0f69a97 100644
> --- a/drivers/platform/x86/asus-wmi.c
> +++ b/drivers/platform/x86/asus-wmi.c
> @@ -1461,14 +1461,9 @@ static int asus_wmi_platform_init(struct asus_wmi *asus)
>         */
>        if (!asus_wmi_evaluate_method(ASUS_WMI_METHODID_DSTS, 0, 0, NULL))
>                asus->dsts_id = ASUS_WMI_METHODID_DSTS;
> -       else if (!asus_wmi_evaluate_method(ASUS_WMI_METHODID_DSTS2, 0, 0, NULL))
> +       else
>                asus->dsts_id = ASUS_WMI_METHODID_DSTS2;
>
> -       if (!asus->dsts_id) {
> -               pr_err("Can't find DSTS");
> -               return -ENODEV;
> -       }
> -
>        /* CWAP allow to define the behavior of the Fn+F2 key,
>         * this method doesn't seems to be present on Eee PCs */
>        if (asus->driver->quirks->wapf >= 0)
> --
> 1.7.0.4
>

Hum, I don't like acking patches referencing documentation I can't
read, but I don't really have the choice !

Matthew, could you merge this one ?
Thanks,

Acked-By: Corentin Chary <corentin.chary@gmail.com>


-- 
Corentin Chary
http://xf.iksaif.net
