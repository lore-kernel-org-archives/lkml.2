Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175Ab2KNWSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 17:18:21 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:60131 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933152Ab2KNWSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 17:18:20 -0500
Date: Wed, 14 Nov 2012 16:17:38 -0600
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] char/tpm: Remove duplicated lookup table
Message-ID: <20121114221738.GB533@ennui.austin.ibm.com>
References: <1352759838-27175-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352759838-27175-1-git-send-email-peterhuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111422-6078-0000-0000-000011EA3C48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 11:37:17PM +0100, Peter Huewe wrote:
> The entries in tpm_protected_ordinal_duration are exactly the same as
> the first 12 in tpm_ordinal_duration, so we can simply remove this one,
> and save some bytes.
> 
> This does not change the behavior of the driver.
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

 Applied, thanks.

Kent

> ---
> This patch reflects only my opinion and work, 
> and is not related to my employer or anybody else.
> 
>  drivers/char/tpm/tpm.c |   18 +-----------------
>  1 files changed, 1 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> index 93211df..9e3c529 100644
> --- a/drivers/char/tpm/tpm.c
> +++ b/drivers/char/tpm/tpm.c
> @@ -65,21 +65,6 @@ static DECLARE_BITMAP(dev_mask, TPM_NUM_DEVICES);
>   * values of the SHORT, MEDIUM, and LONG durations are retrieved
>   * from the chip during initialization with a call to tpm_get_timeouts.
>   */
> -static const u8 tpm_protected_ordinal_duration[TPM_MAX_PROTECTED_ORDINAL] = {
> -	TPM_UNDEFINED,		/* 0 */
> -	TPM_UNDEFINED,
> -	TPM_UNDEFINED,
> -	TPM_UNDEFINED,
> -	TPM_UNDEFINED,
> -	TPM_UNDEFINED,		/* 5 */
> -	TPM_UNDEFINED,
> -	TPM_UNDEFINED,
> -	TPM_UNDEFINED,
> -	TPM_UNDEFINED,
> -	TPM_SHORT,		/* 10 */
> -	TPM_SHORT,
> -};
> -
>  static const u8 tpm_ordinal_duration[TPM_MAX_ORDINAL] = {
>  	TPM_UNDEFINED,		/* 0 */
>  	TPM_UNDEFINED,
> @@ -357,8 +342,7 @@ unsigned long tpm_calc_ordinal_duration(struct tpm_chip *chip,
>  	else if ((ordinal & TPM_PROTECTED_ORDINAL_MASK) <
>  		 TPM_MAX_PROTECTED_ORDINAL)
>  		duration_idx =
> -		    tpm_protected_ordinal_duration[ordinal &
> -						   TPM_PROTECTED_ORDINAL_MASK];
> +		    tpm_ordinal_duration[ordinal & TPM_PROTECTED_ORDINAL_MASK];
> 
>  	if (duration_idx != TPM_UNDEFINED)
>  		duration = chip->vendor.duration[duration_idx];
> -- 
> 1.7.8.6
> 

