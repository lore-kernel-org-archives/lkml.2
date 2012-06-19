Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab2FSHR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 03:17:28 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:35274 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab2FSHR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 03:17:27 -0400
Date: Tue, 19 Jun 2012 10:16:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, devel@driverdev.osuosl.org,
        linaro-kernel@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        patches@linaro.org, Marco Stornelli <marco.stornelli@gmail.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        arve@android.com, Jesper Juhl <jj@chaosbits.net>,
        John Stultz <john.stultz@linaro.org>, Shuah Khan <shuahkhan@gmail.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, kernel-team@android.com,
        Thomas Meyer <thomas@m3y3r.de>
Subject: Re: [PATCH 6/7] pstore/ram: Make ECC size configurable
Message-ID: <20120619071632.GQ4400@mwanda>
References: <20120619021050.GA19387@lizard>
 <1340072156-6225-6-git-send-email-anton.vorontsov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340072156-6225-6-git-send-email-anton.vorontsov@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 07:15:55PM -0700, Anton Vorontsov wrote:
> @@ -478,7 +478,7 @@ static void ramoops_register_dummy(void)
>  	dummy_data->record_size = record_size;
>  	dummy_data->console_size = ramoops_console_size;
>  	dummy_data->dump_oops = dump_oops;
> -	dummy_data->ecc = ramoops_ecc;
> +	dummy_data->ecc_size = ramoops_ecc == 1 ? 16 : ramoops_ecc;
>  

I know it's in the change log, but there should probably be a
comment here as well that 1 and 16 are magic backwards compatability
numbers.

>  	dummy = platform_device_register_data(NULL, "ramoops", -1,
>  			dummy_data, sizeof(struct ramoops_platform_data));

regards,
dan carpenter

