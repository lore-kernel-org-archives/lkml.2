Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab0CTAR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 20:17:28 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:41604 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752440Ab0CTAR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 20:17:27 -0400
Date: Sat, 20 Mar 2010 01:17:14 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sankar P <sankar.curiosity@gmail.com>
Cc: gregkh@suse.de, penberg@cs.helsinki.fi, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] staging: winbond: Convert typedef struct
	_MLME_FRAME to struct
Message-ID: <20100320001714.GF1477@ucw.cz>
References: <1269031264-2327-1-git-send-email-sankar.curiosity@gmail.com> <1269031264-2327-2-git-send-email-sankar.curiosity@gmail.com> <1269031264-2327-3-git-send-email-sankar.curiosity@gmail.com> <1269031264-2327-4-git-send-email-sankar.curiosity@gmail.com> <1269031264-2327-5-git-send-email-sankar.curiosity@gmail.com> <1269031264-2327-6-git-send-email-sankar.curiosity@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269031264-2327-6-git-send-email-sankar.curiosity@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2010-03-20 02:11:03, Sankar P wrote:
> This patch converts the typedef struct _MLME_FRAME to
> struct mlme_frame and updates the places where it is used.
> 
> Signed-off-by: Sankar P <sankar.curiosity@gmail.com>

Ack.

> ---
>  drivers/staging/winbond/core.h   |    2 +-
>  drivers/staging/winbond/mlme_s.h |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/winbond/core.h b/drivers/staging/winbond/core.h
> index 0a2060b..372053a 100644
> --- a/drivers/staging/winbond/core.h
> +++ b/drivers/staging/winbond/core.h
> @@ -16,7 +16,7 @@ struct wbsoft_priv {
>  
>  	struct wb_local_para sLocalPara;	// Myself connected parameters
>  
> -	MLME_FRAME sMlmeFrame;	// connect to peerSTA parameters
> +	struct mlme_frame sMlmeFrame;	/* connect to peerSTA parameters */
>  
>  	struct wb35_mto_params sMtoPara;	// MTO_struct ...
>  	struct hw_data sHwData;	//For HAL
> diff --git a/drivers/staging/winbond/mlme_s.h b/drivers/staging/winbond/mlme_s.h
> index 1217a1c..c95debf 100644
> --- a/drivers/staging/winbond/mlme_s.h
> +++ b/drivers/staging/winbond/mlme_s.h
> @@ -131,7 +131,7 @@
>  #define boMLME_IdleScanState(_BB_)	(_BB_->wState==IDLE_SCAN)
>  #define boMLME_FoundSTAinfo(_CC_)	(_CC_->wState>=IDLE_SCAN)
>  
> -typedef struct _MLME_FRAME
> +struct mlme_frame
>  {
>  	//NDIS_PACKET		MLME_Packet;
>  	s8 *			pMMPDU;
> @@ -156,7 +156,7 @@ typedef struct _MLME_FRAME
>  	u16		wNumRxMMPDUInMLME; 	// Number of the Rx MMPDU
>  	u16		reserved_1;			//  in MLME.
>                      	            //  excluding the discarded
> -} MLME_FRAME, *psMLME_FRAME;
> +};
>  
>  typedef struct _AUTHREQ {
>  

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
