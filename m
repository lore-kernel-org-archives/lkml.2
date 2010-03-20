Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab0CTAPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 20:15:19 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:47587 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752427Ab0CTAPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 20:15:17 -0400
Date: Sat, 20 Mar 2010 01:15:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sankar P <sankar.curiosity@gmail.com>
Cc: gregkh@suse.de, penberg@cs.helsinki.fi, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] staging: winbond: Convert typedef struct
	_STRUCT_SELECTOR
Message-ID: <20100320001506.GD1477@ucw.cz>
References: <1269031264-2327-1-git-send-email-sankar.curiosity@gmail.com> <1269031264-2327-2-git-send-email-sankar.curiosity@gmail.com> <1269031264-2327-3-git-send-email-sankar.curiosity@gmail.com> <1269031264-2327-4-git-send-email-sankar.curiosity@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269031264-2327-4-git-send-email-sankar.curiosity@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2010-03-20 02:11:01, Sankar P wrote:
> This patch converts the declaration typedef struct _STRUCT_SELECTOR
> to struct struct_selector and also the places where it was used.
> 
> Signed-off-by: Sankar P <sankar.curiosity@gmail.com>

ack.

> ---
>  drivers/staging/winbond/mac_structures.h |   18 +++++++++---------
>  1 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/winbond/mac_structures.h b/drivers/staging/winbond/mac_structures.h
> index 7eb0e57..4130cf6 100644
> --- a/drivers/staging/winbond/mac_structures.h
> +++ b/drivers/staging/winbond/mac_structures.h
> @@ -436,7 +436,7 @@ struct Extended_Supported_Rates_Element
>  #define OUI_CIPHER_CCMP				0x04
>  #define OUI_CIPHER_WEP_104			0x05
>  
> -typedef struct _SUITE_SELECTOR_
> +struct suite_selector
>  {
>  	union
>  	{
> @@ -447,23 +447,23 @@ typedef struct _SUITE_SELECTOR_
>  			u8	Type;
>  		}SuitSelector;
>  	};
> -}SUITE_SELECTOR;
> +};
>  
>  //--  WPA  --
>  struct	RSN_Information_Element
>  {
>  	u8					Element_ID;
>  	u8					Length;
> -	SUITE_SELECTOR	OuiWPAAdditional;//WPA version 2.0 additional field, and should be 00:50:F2:01
> +	struct suite_selector	OuiWPAAdditional; /* WPA version 2.0 additional field, and should be 00:50:F2:01 */
>  	u16					Version;
> -	SUITE_SELECTOR		GroupKeySuite;
> +	struct suite_selector		GroupKeySuite;
>  	u16					PairwiseKeySuiteCount;
> -	SUITE_SELECTOR		PairwiseKeySuite[1];
> +	struct suite_selector		PairwiseKeySuite[1];
>  }__attribute__ ((packed));
>  struct RSN_Auth_Sub_Information_Element
>  {
>  	u16				AuthKeyMngtSuiteCount;
> -	SUITE_SELECTOR	AuthKeyMngtSuite[1];
> +	struct suite_selector	AuthKeyMngtSuite[1];
>  }__attribute__ ((packed));
>  
>  //--  WPA2  --
> @@ -508,16 +508,16 @@ struct	WPA2_RSN_Information_Element
>  	u8					Element_ID;
>  	u8					Length;
>  	u16					Version;
> -	SUITE_SELECTOR		GroupKeySuite;
> +	struct suite_selector		GroupKeySuite;
>  	u16					PairwiseKeySuiteCount;
> -	SUITE_SELECTOR		PairwiseKeySuite[1];
> +	struct suite_selector		PairwiseKeySuite[1];
>  
>  }__attribute__ ((packed));
>  
>  struct WPA2_RSN_Auth_Sub_Information_Element
>  {
>  	u16				AuthKeyMngtSuiteCount;
> -	SUITE_SELECTOR	AuthKeyMngtSuite[1];
> +	struct suite_selector	AuthKeyMngtSuite[1];
>  }__attribute__ ((packed));
>  
>  

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
