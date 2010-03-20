Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab0CTASB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 20:18:01 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:41611 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752440Ab0CTAR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 20:17:59 -0400
Date: Sat, 20 Mar 2010 01:17:48 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sankar P <sankar.curiosity@gmail.com>
Cc: gregkh@suse.de, penberg@cs.helsinki.fi, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] staging: winbond: Convert typedef struct
	_SCAN_REQ_PARA to struct
Message-ID: <20100320001748.GG1477@ucw.cz>
References: <1269031264-2327-1-git-send-email-sankar.curiosity@gmail.com> <1269031264-2327-2-git-send-email-sankar.curiosity@gmail.com> <1269031264-2327-3-git-send-email-sankar.curiosity@gmail.com> <1269031264-2327-4-git-send-email-sankar.curiosity@gmail.com> <1269031264-2327-5-git-send-email-sankar.curiosity@gmail.com> <1269031264-2327-6-git-send-email-sankar.curiosity@gmail.com> <1269031264-2327-7-git-send-email-sankar.curiosity@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269031264-2327-7-git-send-email-sankar.curiosity@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2010-03-20 02:11:04, Sankar P wrote:
> This patch converts typedef struct _SCAN_REQ_PARA to
> struct scan_req_para and the places where it is used.
> 
> Signed-off-by: Sankar P <sankar.curiosity@gmail.com>

ack.

> ---
>  drivers/staging/winbond/scan_s.h |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/winbond/scan_s.h b/drivers/staging/winbond/scan_s.h
> index 209717f..e677fc4 100644
> --- a/drivers/staging/winbond/scan_s.h
> +++ b/drivers/staging/winbond/scan_s.h
> @@ -31,7 +31,9 @@
>  
>  ///////////////////////////////////////////////////////////////////////////
>  //Global data structures, Initial Scan & Background Scan
> -typedef struct _SCAN_REQ_PARA	//mandatory parameters for SCAN request
> +
> +/* Mandatory parameters for SCAN request */
> +struct scan_req_para
>  {
>  	u32				ScanType;			//passive/active scan
>  
> @@ -40,14 +42,14 @@ typedef struct _SCAN_REQ_PARA	//mandatory parameters for SCAN request
>  	struct SSID_Element	sSSID; // 34B. scan only for this SSID
>  	u8			reserved_2[2];
>  
> -} SCAN_REQ_PARA, *psSCAN_REQ_PARA;
> +};
>  
>  typedef struct _SCAN_PARAMETERS
>  {
>  	u16				wState;
>  	u16				iCurrentChannelIndex;
>  
> -	SCAN_REQ_PARA	sScanReq;
> +	struct scan_req_para	sScanReq;
>  
>  	u8				BSSID[MAC_ADDR_LENGTH + 2];		//scan only for this BSSID
>  

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
