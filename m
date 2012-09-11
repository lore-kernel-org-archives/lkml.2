Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab2IKXKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 19:10:05 -0400
Received: from prod-mail-xrelay01.akamai.com ([72.246.2.12]:39203 "EHLO
	prod-mail-xrelay01.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750934Ab2IKXKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 19:10:03 -0400
X-Greylist: delayed 480 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Sep 2012 19:10:02 EDT
Message-ID: <504FC2E9.4010708@akamai.com>
Date: Tue, 11 Sep 2012 18:02:01 -0500
From: Josh Hunt <johunt@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Josh Hunt <johunt@akamai.com>
CC: "borislav.petkov@amd.com" <borislav.petkov@amd.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] amd64_edac: Memory size reported double on processor
 family 0Fh
References: <1347403947-20187-1-git-send-email-johunt@akamai.com>
In-Reply-To: <1347403947-20187-1-git-send-email-johunt@akamai.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[fixing lkml address]

On 09/11/2012 05:52 PM, Josh Hunt wrote:
> With recent kernels we noticed that edac was reporting double the memory size on
> systems running with AMD family 0Fh processors. I'm not very familiar with the
> code, but this resolves it from what I can see on my systems. At least in
> amd64_debug_display_dimm_sizes() and k8_dbam_to_chip_select() there appeared
> to be redundant shifts to the left by 1 when WIDTH_128 is present.
>
> thanks
> Josh
>
> ---
>
> Since commit 41d8bfaba70311c2fa0666554ef160ea8ffc9daf the memory size reported
> by edac has been double. Adding to the shift if WIDTH_128 is set looks to be
> redundant, removing.
>
> Signed-off-by: Josh Hunt <johunt@akamai.com>
> ---
>   drivers/edac/amd64_edac.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index 5a297a2..c796710 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -1123,7 +1123,7 @@ static int k8_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
>
>   	if (pvt->ext_model >= K8_REV_F) {
>   		WARN_ON(cs_mode > 11);
> -		return ddr2_cs_size(cs_mode, dclr & WIDTH_128);
> +		return ddr2_cs_size(cs_mode, 0);
>   	}
>   	else if (pvt->ext_model >= K8_REV_D) {
>   		unsigned diff;
>

