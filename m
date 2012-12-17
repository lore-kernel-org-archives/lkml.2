Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab2LQOCE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 09:02:04 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:42586 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab2LQOCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 09:02:02 -0500
Date: Mon, 17 Dec 2012 17:00:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sebastian Wankerl <sisewank@cip.cs.fau.de>
Cc: linux-kernel@i4.informatik.uni-erlangen.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sebastian Wankerl 
	<sisewank@faui49man10.informatik.uni-erlangen.de>
Subject: Re: [PATCH 1/3] wlan-ng/prism2mgmt.c: added parenthesis to macro
Message-ID: <20121217140004.GQ5083@mwanda>
References: <1355751483-7059-1-git-send-email-sisewank@cip.cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355751483-7059-1-git-send-email-sisewank@cip.cs.fau.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 02:38:01PM +0100, Sebastian Wankerl wrote:
> From: Sebastian Wankerl <sisewank@faui49man10.informatik.uni-erlangen.de>
> 
> Signed-off-by: Sebastian Wankerl <sisewank@cip.cs.fau.de> 
> Signed-off-by: Sebastian Ehrenfels <qi50dube@cip.cs.fau.de> 
> 
> ---
>  drivers/staging/wlan-ng/prism2mgmt.c |   25 +++++++++++++++----------
>  1 file changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/staging/wlan-ng/prism2mgmt.c b/drivers/staging/wlan-ng/prism2mgmt.c
> index 4efa9bc..62b94b0 100644
> --- a/drivers/staging/wlan-ng/prism2mgmt.c
> +++ b/drivers/staging/wlan-ng/prism2mgmt.c
> @@ -415,11 +415,14 @@ int prism2mgmt_scan_results(wlandevice_t *wlandev, void *msgp)
>  			break;
>  
>  #define REQBASICRATE(N) \
> -	if ((count >= N) && DOT11_RATE5_ISBASIC_GET(item->supprates[(N)-1])) { \
> -		req->basicrate ## N .data = item->supprates[(N)-1]; \
> -		req->basicrate ## N .status = \
> -			P80211ENUM_msgitem_status_data_ok; \
> -	}
> +	do { \
> +		if ((count >= N) && DOT11_RATE5_ISBASIC_GET( \
> +			item->supprates[(N)-1])) { \

This is a very confusing way to indent.  The proper way is:

	do {                                                                \
		if (count >= N &&                                           \
		    DOT11_RATE5_ISBASIC_GET(item->supprates[(N)-1])) {      \

The "DOT11_RATE5_ISBASIC_GET(item->supprates[(N)-1])" call should be
on one line if possible.

The start 'c' in count and the 'D' in DOT11_ should be in the same
column.  You will need to add some space characters to make this
work.

> +			req->basicrate ## N .data = item->supprates[(N)-1]; \
> +			req->basicrate ## N .status = \
> +				P80211ENUM_msgitem_status_data_ok; \
> +		} \

regards,
dan carpenter
