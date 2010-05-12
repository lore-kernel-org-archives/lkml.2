Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab0ELKvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 06:51:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49195 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489Ab0ELKvP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 06:51:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SF0DQDszcwcuOteULtCHXIdumY8fHz0k9rKiE8qN1dCEJ7l3/X9f198Hb+SKYr2TLv
         PY4wIOeHCLYXP/E22tFaHmjipteYrMnPhZoUoXXSz8K3aMAzEzXynvYG6o2dNIJJO4O5
         2JCgdWSXja3OeQyt1P30knXNM0b0iD13VfsCw=
MIME-Version: 1.0
In-Reply-To: <1273623083.2314.4.camel@localhost.localdomain>
References: <1273623083.2314.4.camel@localhost.localdomain>
Date: Wed, 12 May 2010 13:51:13 +0300
Message-ID: <AANLkTimUrjqc3cVt7pDcPZ_-GSalU4mCL5TfetdT-Sel@mail.gmail.com>
Subject: Re: [PATCH] Disable i8042 checks on Intel Apple Macs
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Bastien Nocera <hadess@hadess.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 3:11 AM, Bastien Nocera <hadess@hadess.net> wrote:
> As those computers never had any i8042 controllers, and the
> current lookup code could potentially lock up/hang/wait for
> timeout for long periods of time.
>
> Fixes intermittent hangs on boot on a MacbookAir1,1
>
> Signed-off-by: Bastien Nocera <hadess@hadess.net>
> ---
>  drivers/input/serio/i8042-x86ia64io.h |   18 ++++++++++++++++++
>  1 files changed, 18 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
> index ead0494..e859902 100644
> --- a/drivers/input/serio/i8042-x86ia64io.h
> +++ b/drivers/input/serio/i8042-x86ia64io.h
> @@ -479,6 +479,22 @@ static const struct dmi_system_id __initconst i8042_dmi_reset_table[] = {
>        { }
>  };
>
> +/* Intel Apple Macs never have an i8042 controller,
> + * so we shouldn't even try to probe for it */
> +static const struct dmi_system_id __initconst i8042_dmi_no_probe_table[] = {
> +       {
> +               .matches = {
> +                       DMI_MATCH(DMI_BIOS_VENDOR, "Apple Computer, Inc.")
> +               },
> +       },
> +       {
> +               .matches = {
> +                       DMI_MATCH(DMI_BIOS_VENDOR, "Apple Inc.")
> +               },
> +       },
> +       {}

No need for that extra {}

-- 
Felipe Contreras
