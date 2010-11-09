Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab0KIVgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:36:46 -0500
Received: from kroah.org ([198.145.64.141]:35075 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755226Ab0KIVgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:36:43 -0500
Date: Tue, 9 Nov 2010 13:23:22 -0800
From: Greg KH <greg@kroah.com>
To: Neil Munro <neilmunro@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: RT2860: Fixed multiple errors in
 rtusb_io.h
Message-ID: <20101109212322.GA16104@kroah.com>
References: <1287861137-4272-1-git-send-email-neilmunro@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287861137-4272-1-git-send-email-neilmunro@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 23, 2010 at 08:12:17PM +0100, Neil Munro wrote:
> Fixed the errors in rtusb_io.h

"errors"?  What type of errors?  Do you mean checkpatch.pl
warnings/errors?

> 
> Signed-off-by: Neil Munro <neilmunro@gmail.com>
> ---
>  drivers/staging/rt2860/rtusb_io.h |   44 +++++++++++++++++++-----------------
>  1 files changed, 23 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/staging/rt2860/rtusb_io.h b/drivers/staging/rt2860/rtusb_io.h
> index 64a2fe4..bbb34d2 100644
> --- a/drivers/staging/rt2860/rtusb_io.h
> +++ b/drivers/staging/rt2860/rtusb_io.h
> @@ -144,42 +144,44 @@ struct rt_cmdq {
> 
>  /* add Client security information into ASIC WCID table and IVEIV table */
>  #define RTMP_STA_SECURITY_INFO_ADD(pAd, apidx, KeyID, pEntry)						\
> -	{	RTMP_STA_ENTRY_MAC_RESET(pAd, pEntry->Aid);								\
> -		if (pEntry->Aid >= 1) {														\
> -			struct rt_set_asic_wcid_attri	SetAsicWcidAttri;								\
> -			SetAsicWcidAttri.WCID = pEntry->Aid;									\
> -			if ((pEntry->AuthMode <= Ndis802_11AuthModeAutoSwitch) &&				\
> -				(pEntry->WepStatus == Ndis802_11Encryption1Enabled))				\
> -			{																		\
> -				SetAsicWcidAttri.Cipher = pAd->SharedKey[apidx][KeyID].CipherAlg;	\
> -			}																		\
> -			else if (pEntry->AuthMode == Ndis802_11AuthModeWPANone)					\
> -			{																		\
> -				SetAsicWcidAttri.Cipher = pAd->SharedKey[apidx][KeyID].CipherAlg;	\
> -			}																		\
> -			else SetAsicWcidAttri.Cipher = 0;										\
> -            DBGPRINT(RT_DEBUG_TRACE, ("aid cipher = %ld\n",SetAsicWcidAttri.Cipher));       \
> +{
> +	RTMP_STA_ENTRY_MAC_RESET(pAd, pEntry->Aid);								\
> +	if (pEntry->Aid >= 1) {														\
> +		struct rt_set_asic_wcid_attri	SetAsicWcidAttri;								\
> +		SetAsicWcidAttri.WCID = pEntry->Aid;									\
> +		if ((pEntry->AuthMode <= Ndis802_11AuthModeAutoSwitch) &&				\

Are you sure this is still all ok?  The tabs look pretty wrong and
the ends of the line should be smaller, right?

If you are going to fix up the spacing, please also fix the length of
the lines at the same time, especially when it is so easy to do so.

Care to resend this?

thanks,

greg k-h
