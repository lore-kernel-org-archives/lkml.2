Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab2AZROu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 12:14:50 -0500
Received: from imr4.ericy.com ([198.24.6.9]:44990 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435Ab2AZROt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 12:14:49 -0500
Message-ID: <1327597937.2649.216.camel@groeck-laptop>
Subject: Re: [PATCH] applesmc: Silence uninitialized warnings
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Henrik Rydberg <rydberg@euromail.se>
CC: Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 26 Jan 2012 09:12:17 -0800
In-Reply-To: <1327576121-2073-1-git-send-email-rydberg@euromail.se>
References: <1327576121-2073-1-git-send-email-rydberg@euromail.se>
Organization: Ericsson
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-26 at 06:08 -0500, Henrik Rydberg wrote:
> Some error paths do not set a result, leading to the (false)
> assumption that the value may be used uninitialized. Set results for
> those paths as well.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  drivers/hwmon/applesmc.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
> index b989553..11f79bb 100644
> --- a/drivers/hwmon/applesmc.c
> +++ b/drivers/hwmon/applesmc.c
> @@ -344,8 +344,10 @@ static int applesmc_get_lower_bound(unsigned int *lo, const char *key)
>  	while (begin != end) {
>  		int middle = begin + (end - begin) / 2;
>  		entry = applesmc_get_entry_by_index(middle);
> -		if (IS_ERR(entry))
> +		if (IS_ERR(entry)) {
> +			*lo = 0;
>  			return PTR_ERR(entry);
> +		}
>  		if (strcmp(entry->key, key) < 0)
>  			begin = middle + 1;
>  		else
> @@ -364,8 +366,10 @@ static int applesmc_get_upper_bound(unsigned int *hi, const char *key)
>  	while (begin != end) {
>  		int middle = begin + (end - begin) / 2;
>  		entry = applesmc_get_entry_by_index(middle);
> -		if (IS_ERR(entry))
> +		if (IS_ERR(entry)) {
> +			*hi = smcreg.key_count;
>  			return PTR_ERR(entry);
> +		}
>  		if (strcmp(key, entry->key) < 0)
>  			end = middle;
>  		else

That was an annoying warning .. I checked the code several times by now
to make sure it is not real. Good idea to fix it.

Applied to -next for now. Linus did not (yet) accept my last set of
patches, so I am not sure if it was too much cleanup for a release
candidate.

Guenter


