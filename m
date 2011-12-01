Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab1LASjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 13:39:22 -0500
Received: from void.printf.net ([89.145.121.20]:56767 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755783Ab1LASjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 13:39:19 -0500
From: Chris Ball <cjb@laptop.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH 07/11] mmc: Remove redundant spi driver bus initialization
References: <1322148561-25138-1-git-send-email-lars@metafoo.de>
	<1322148561-25138-7-git-send-email-lars@metafoo.de>
Date: Thu, 01 Dec 2011 13:39:25 -0500
In-Reply-To: <1322148561-25138-7-git-send-email-lars@metafoo.de> (Lars-Peter
	Clausen's message of "Thu, 24 Nov 2011 16:29:17 +0100")
Message-ID: <8739d4kug2.fsf@laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars,

On Thu, Nov 24 2011, Lars-Peter Clausen wrote:
> In ancient times it was necessary to manually initialize the bus field of an
> spi_driver to spi_bus_type. These days this is done in spi_driver_register(),
> so we can drop the manual assignment.
>
> The patch was generated using the following coccinelle semantic patch:
> // <smpl>
> @@
> identifier _driver;
> @@
> struct spi_driver _driver = {
> 	.driver = {
> -		.bus = &spi_bus_type,
> 	},
> };
> // </smpl>
>
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Chris Ball <cjb@laptop.org>
> Cc: linux-mmc@vger.kernel.org
> ---
>  drivers/mmc/host/mmc_spi.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
> index 92946b8..273306c 100644
> --- a/drivers/mmc/host/mmc_spi.c
> +++ b/drivers/mmc/host/mmc_spi.c
> @@ -1525,7 +1525,6 @@ static struct of_device_id mmc_spi_of_match_table[] __devinitdata = {
>  static struct spi_driver mmc_spi_driver = {
>  	.driver = {
>  		.name =		"mmc_spi",
> -		.bus =		&spi_bus_type,
>  		.owner =	THIS_MODULE,
>  		.of_match_table = mmc_spi_of_match_table,
>  	},

Thanks, pushed to mmc-next for 3.3.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
