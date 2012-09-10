Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab2IJJM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 05:12:57 -0400
Received: from ppsw-43.csi.cam.ac.uk ([131.111.8.143]:32778 "EHLO
	ppsw-43.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab2IJJMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 05:12:55 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <504DAF19.3050701@jic23.retrosnub.co.uk>
Date: Mon, 10 Sep 2012 10:12:57 +0100
From: Jonathan Cameron <jic23@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: "Kim, Milo" <Milo.Kim@ti.com>
CC: Jonathan Cameron <jic23@kernel.org>, Jonathan Cameron <jic23@cam.ac.uk>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] iio: inkern: clear allocated memory
References: <A874F61F95741C4A9BA573A70FE3998F41EF45DC@DQHE02.ent.ti.com>
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF45DC@DQHE02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/12 09:02, Kim, Milo wrote:
>   Use kzalloc() rathern than kmalloc() for initializing iio_dev and
>   iio_chan_spec.
Please state why.  I'm sure I can track it down, but it ought to be
in the commit comment.
>
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>   drivers/iio/inkern.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
> index b5afc2f..1faa240 100644
> --- a/drivers/iio/inkern.c
> +++ b/drivers/iio/inkern.c
> @@ -130,7 +130,7 @@ struct iio_channel *iio_channel_get(const char *name, const char *channel_name)
>   	if (c == NULL)
>   		return ERR_PTR(-ENODEV);
>
> -	channel = kmalloc(sizeof(*channel), GFP_KERNEL);
> +	channel = kzalloc(sizeof(*channel), GFP_KERNEL);
>   	if (channel == NULL)
>   		return ERR_PTR(-ENOMEM);
>
>

