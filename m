Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab0LGBot (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 20:44:49 -0500
Received: from mail-qw0-f43.google.com ([209.85.216.43]:55745 "EHLO
	mail-qw0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab0LGBor convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 20:44:47 -0500
X-Greylist: delayed 498 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Dec 2010 20:44:47 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=wWQtrWfgoJLyYXzSQ80CU18I/Srf9wAXdOgcOxkDGAwFzrb2dEqYfQkNi46kbva2ET
         R6KWHsrWP3V94Sy3lr22P9f4CNi3Fbd1VBxo4TIvklQcEBR4Q+sniFeVlcAAVcyqDZ+/
         sAn0vOSluBQH335yG/1xXDIfeGQYlyZEd5RFY=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1012061734590.13430@utopia.booyaka.com>
References: <alpine.DEB.2.00.1012061734590.13430@utopia.booyaka.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Tue, 7 Dec 2010 09:36:09 +0800
X-Google-Sender-Auth: 1o0sU_81zceaiwLYihbCdBg2kks
Message-ID: <AANLkTimXPFROMQ_fF4Od-jw3aDY0WZQgc=x14=VcFM3d@mail.gmail.com>
Subject: Re: [PATCH] MFD: TWL/TPS: fix twl_probe section mismatch warning in mfd/twl-core.c
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 7, 2010 at 8:35 AM, Paul Walmsley <paul@pwsan.com> wrote:
>
> Fix the following section mismatch warning when building omap2plus_defconfig:
>
> WARNING: vmlinux.o(.data+0x47d7c): Section mismatch in reference from the variable twl_driver to the function .init.text:twl_probe()
>
> Signed-off-by: Paul Walmsley <paul@pwsan.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> ---
>  drivers/mfd/twl-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
> index 35275ba..615cf38 100644
> --- a/drivers/mfd/twl-core.c
> +++ b/drivers/mfd/twl-core.c
> @@ -969,7 +969,7 @@ static int twl_remove(struct i2c_client *client)
>  }
>
>  /* NOTE:  this driver only handles a single twl4030/tps659x0 chip */
> -static int __init
> +static int

I think we might change __init to __devinit.

>  twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  {
>        int                             status;
> --

Thanks,
-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.138-1617-6545 Mobile
Ubuntu Kernel Team
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
