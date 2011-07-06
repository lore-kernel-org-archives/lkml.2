Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab1GFIbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 04:31:31 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:42245 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab1GFIb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 04:31:29 -0400
Date: Wed, 6 Jul 2011 10:31:16 +0200
From: Anisse Astier <anisse@astier.eu>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>,
        Thomas Renninger <trenn@suse.de>, Matthew Garrett <mjg@redhat.com>,
        platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] platform-drivers-x86: msi-wmi: add missing
 sparse_keymap_free in msi_wmi_init error path
Message-ID: <20110706103116.1949d632@destiny.ordissimo>
In-Reply-To: <1309921520.26847.3.camel@phoenix>
References: <1309921520.26847.3.camel@phoenix>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jul 2011 11:05:20 +0800, Axel Lin <axel.lin@gmail.com> wrote :

> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/platform/x86/msi-wmi.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/platform/x86/msi-wmi.c b/drivers/platform/x86/msi-wmi.c
> index c832e33..6f40bf2 100644
> --- a/drivers/platform/x86/msi-wmi.c
> +++ b/drivers/platform/x86/msi-wmi.c
> @@ -272,6 +272,7 @@ static int __init msi_wmi_init(void)
>  err_free_backlight:
>  	backlight_device_unregister(backlight);
>  err_free_input:
> +	sparse_keymap_free(msi_wmi_input_dev);
>  	input_unregister_device(msi_wmi_input_dev);

Nice catch ! Maybe doing the init in two different functions wasn't the
best for error handling.

Acked-by: Anisse Astier <anisse@astier.eu>

PS: It might already have been asked, but what's your secret Axel ? Do
you use static/dynamic analysis tools ? Which ones ?
