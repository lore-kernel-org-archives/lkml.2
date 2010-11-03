Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514Ab0KCSoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 14:44:00 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:43459 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932420Ab0KCSn5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 14:43:57 -0400
MIME-Version: 1.0
In-Reply-To: <20101103181400.GA12818@core.coreip.homeip.net>
References: <20101103181400.GA12818@core.coreip.homeip.net>
Date: Wed, 3 Nov 2010 13:43:57 -0500
Message-ID: <AANLkTi=4U_kE6+V13=wJM+_7=iZW3NGew=jWcddDMO+m@mail.gmail.com>
Subject: Re: [PATCH] eeepc-wmi: fix compiler warning
From: Chris Bagwell <chris@cnpbagwell.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 3, 2010 at 1:14 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> This fixes the following:
>
>  CC [M]  drivers/platform/x86/eeepc-wmi.o
> drivers/platform/x86/eeepc-wmi.c:322: warning: initialization from incompatible pointer type
>
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---
>
>  drivers/platform/x86/eeepc-wmi.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
>
> diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
> index 462ceab..0d50fbb 100644
> --- a/drivers/platform/x86/eeepc-wmi.c
> +++ b/drivers/platform/x86/eeepc-wmi.c
> @@ -298,8 +298,8 @@ static void eeepc_wmi_notify(u32 value, void *context)
>        kfree(obj);
>  }
>
> -static int store_cpufv(struct device *dev, struct device_attribute *attr,
> -                      const char *buf, size_t count)
> +static ssize_t store_cpufv(struct device *dev, struct device_attribute *attr,
> +                          const char *buf, size_t count)
>  {
>        int value;
>        struct acpi_buffer input = { (acpi_size)sizeof(value), &value };
> --

Opps.  Sorry, I missed that warning.  ssize_t is obviously correct return value.

Reviewed-by: Chris Bagwell <chris@cnpbagwell.com>
