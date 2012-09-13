Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab2IMD4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 23:56:24 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53523 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293Ab2IMD4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 23:56:22 -0400
MIME-Version: 1.0
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF49D3@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F41EF49D3@DQHE02.ent.ti.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Thu, 13 Sep 2012 11:56:01 +0800
X-Google-Sender-Auth: VP3lCp1hxkwrrTuTQgLEwO81z1I
Message-ID: <CAK5ve-KfmgGOVSS4ic1-qiSXaGcbmnu17C9CBhcYoZEtr0fPbQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] leds-lp5523: Fix riskiness of the page fault
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 8:16 PM, Kim, Milo <Milo.Kim@ti.com> wrote:
>  The last attribute should be terminated as NULL because any member of
>  attribute structure is accessed while adding the sysfs file.
>  If not, invalid address may cause the page fault problem.
>

Thanks, applied
-Bryan

> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  drivers/leds/leds-lp5523.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
> index 5ebdc92..97994ff 100644
> --- a/drivers/leds/leds-lp5523.c
> +++ b/drivers/leds/leds-lp5523.c
> @@ -759,6 +759,7 @@ static struct attribute *lp5523_attributes[] = {
>         &dev_attr_engine2_leds.attr,
>         &dev_attr_engine3_load.attr,
>         &dev_attr_engine3_leds.attr,
> +       NULL,
>  };
>
>  static const struct attribute_group lp5523_group = {
> --
> 1.7.9.5
>
>
> Best Regards,
> Milo
>
>



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
