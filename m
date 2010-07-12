Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab0GLXO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 19:14:58 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57737 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755557Ab0GLXO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 19:14:56 -0400
Message-ID: <4C3BA1E7.1070607@ti.com>
Date: Mon, 12 Jul 2010 18:14:47 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: "Ramirez Luna, Omar" <omar.ramirez@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Ameya Palande <ameya.palande@nokia.com>,
        "Guzman Lugo, Fernando" <fernando.lugo@ti.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] staging: tidspbridge: fix build error for missing variable
References: <1278975385-7769-1-git-send-email-nm@ti.com>
In-Reply-To: <1278975385-7769-1-git-send-email-nm@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Menon, Nishanth had written, on 07/12/2010 05:56 PM, the following:
> Commit:
> staging: tidspbridge: gen: simplify and clean up
> There is recently added hex_to_bin() kernel's method which we could use
> instead of custom long function.
> 
> Introduced usage of hex_to_bin without defining the temp variable.
> this causes the build error:
> drivers/staging/tidspbridge/gen/uuidutil.c: In function 'uuid_hex_to_bin':
> drivers/staging/tidspbridge/gen/uuidutil.c:63: error: 'value' undeclared (first use in this function)
> drivers/staging/tidspbridge/gen/uuidutil.c:63: error: (Each undeclared identifier is reported only once
> drivers/staging/tidspbridge/gen/uuidutil.c:63: error: for each function it appears in.)
> 
> introduce variable value to fix the error.
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
>  drivers/staging/tidspbridge/gen/uuidutil.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/tidspbridge/gen/uuidutil.c b/drivers/staging/tidspbridge/gen/uuidutil.c
> index eb09bc3..070761b 100644
> --- a/drivers/staging/tidspbridge/gen/uuidutil.c
> +++ b/drivers/staging/tidspbridge/gen/uuidutil.c
> @@ -58,6 +58,7 @@ static s32 uuid_hex_to_bin(char *buf, s32 len)
>  {
>  	s32 i;
>  	s32 result = 0;
> +	int value;
>  
>  	for (i = 0; i < len; i++) {
>  		value = hex_to_bin(*buf++);
arrgh.. just saw https://patchwork.kernel.org/patch/111141/ - please 
consider the same and drop this patch. apologies on the noise.

-- 
Regards,
Nishanth Menon
