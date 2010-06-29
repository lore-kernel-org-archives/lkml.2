Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761Ab0F2Fa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 01:30:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38420 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab0F2FaZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 01:30:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mIYvGpXcXsyWWEE9PqTdRCY9bkxjlxhWruMQqTWMUnBybt938iozgEZknE7v1AvCXs
         +zLY58Y5vtNbbiyseKIy7EbiJjip0nV4fy+EV+VNp3lrdIgJzqjQuQOTnleQBGF9UanK
         RbFueYRUZUXsec+yen4f8kyjZ8Q457YYEHW+g=
MIME-Version: 1.0
In-Reply-To: <1277780987.5478.2.camel@mola>
References: <1277780987.5478.2.camel@mola>
Date: Tue, 29 Jun 2010 07:30:22 +0200
Message-ID: <AANLkTimQPSWFCxhBXPNrCokCkYc3dOoorVCQXxSlsBuE@mail.gmail.com>
Subject: Re: [PATCH] asus-laptop: fix a memory leak in asus_laptop_get_info 
	error path
From: Corentin Chary <corentin.chary@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       acpi4asus-user@lists.sourceforge.net,
       platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 5:09 AM, Axel Lin <axel.lin@gmail.com> wrote:
> The callers of write_acpi_int_ret() pass ACPI_ALLOCATE_BUFFER,
> the caller must kfree the returned buffer if AE_OK is returned.
>
> This patch adds a missing kfree(buffer.pointer) before return -ENOMEM
> if kstrdup fail.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/platform/x86/asus-laptop.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
> index 71db2ef..3d76c6a 100644
> --- a/drivers/platform/x86/asus-laptop.c
> +++ b/drivers/platform/x86/asus-laptop.c
> @@ -1397,8 +1397,10 @@ static int asus_laptop_get_info(struct asus_laptop *asus)
>                }
>        }
>        asus->name = kstrdup(string, GFP_KERNEL);
> -       if (!asus->name)
> +       if (!asus->name) {
> +               kfree(buffer.pointer);
>                return -ENOMEM;
> +       }
>
>        if (*string)
>                pr_notice("  %s model detected\n", string);
> --
> 1.5.4.3
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe platform-driver-x86" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Acked-by: Corentin Chary <corentincj@iksaif.net>

-- 
Corentin Chary
http://xf.iksaif.net
