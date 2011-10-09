Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772Ab1JIL0M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 07:26:12 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35480 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab1JIL0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 07:26:10 -0400
Message-ID: <4E9184C9.8050006@gmail.com>
Date: Sun, 09 Oct 2011 12:26:01 +0100
From: Dave Kilroy <kilroyd@googlemail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: greg@kroah.com, pe1dnn@amsat.org
Subject: Re: [PATCH 3/7] staging: wlags49_h2: Remove useless IWE_STREAM_ADD_YYY
 defines
References: <1318158697-15979-1-git-send-email-kilroyd@googlemail.com> <1318158697-15979-4-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1318158697-15979-4-git-send-email-kilroyd@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LKML didn't like the original title of this patch and rejected the email.

Greg: please let me know if you want me to resend this with an 
'acceptable' title, otherwise you might consider removing the treble X 
from the patch title.


Regards,

Dave

---

On 09/10/2011 12:11, David Kilroy wrote:
> These macros don't map to anything different. Just remove them.
>
> Signed-off-by: David Kilroy<kilroyd@googlemail.com>
> ---
>   drivers/staging/wlags49_h2/wl_wext.c |   33 ++++++++++++++-------------------
>   1 files changed, 14 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/staging/wlags49_h2/wl_wext.c b/drivers/staging/wlags49_h2/wl_wext.c
> index 89563da..c392fd8 100644
> --- a/drivers/staging/wlags49_h2/wl_wext.c
> +++ b/drivers/staging/wlags49_h2/wl_wext.c
> @@ -75,15 +75,6 @@
>   #include<wl_wext.h>
>   #include<wl_priv.h>
>
> -
> -
> -#define IWE_STREAM_ADD_EVENT(info, buf, end, iwe, len) \
> -    iwe_stream_add_event(info, buf, end, iwe, len)
> -#define IWE_STREAM_ADD_POINT(info, buf, end, iwe, msg) \
> -    iwe_stream_add_point(info, buf, end, iwe, msg)
> -
> -
> -
>   /*******************************************************************************
>    * global definitions
>    ******************************************************************************/
> @@ -2681,8 +2672,8 @@ static int wireless_get_scan(struct net_device *dev, struct iw_request_info *inf
>   		memcpy( iwe.u.ap_addr.sa_data, probe_resp->BSSID, ETH_ALEN);
>   		iwe.len                 = IW_EV_ADDR_LEN;
>
> -		buf = IWE_STREAM_ADD_EVENT(info, buf, buf_end,&iwe, IW_EV_ADDR_LEN);
> -
> +		buf = iwe_stream_add_event(info, buf, buf_end,
> +					&iwe, IW_EV_ADDR_LEN);
>
>   		/* Use the mode to indicate if it's a station or AP */
>   		/* Won't always be an AP if in IBSS mode */
> @@ -2698,8 +2689,8 @@ static int wireless_get_scan(struct net_device *dev, struct iw_request_info *inf
>
>   		iwe.len = IW_EV_UINT_LEN;
>
> -		buf = IWE_STREAM_ADD_EVENT(info, buf, buf_end,&iwe, IW_EV_UINT_LEN);
> -
> +		buf = iwe_stream_add_event(info, buf, buf_end,
> +					&iwe, IW_EV_UINT_LEN);
>
>   		/* Any quality information */
>   		memset(&iwe, 0, sizeof(iwe));
> @@ -2711,7 +2702,8 @@ static int wireless_get_scan(struct net_device *dev, struct iw_request_info *inf
>   		iwe.u.qual.updated  = lp->probe_results.scan_complete | IW_QUAL_DBM;
>   		iwe.len             = IW_EV_QUAL_LEN;
>
> -		buf = IWE_STREAM_ADD_EVENT(info, buf, buf_end,&iwe, IW_EV_QUAL_LEN);
> +		buf = iwe_stream_add_event(info, buf, buf_end,
> +					&iwe, IW_EV_QUAL_LEN);
>
>
>   		/* ESSID information */
> @@ -2722,7 +2714,8 @@ static int wireless_get_scan(struct net_device *dev, struct iw_request_info *inf
>   			iwe.u.data.length = probe_resp->rawData[1];
>   			iwe.u.data.flags = 1;
>
> -			buf = IWE_STREAM_ADD_POINT(info, buf, buf_end,&iwe,&probe_resp->rawData[2]);
> +			buf = iwe_stream_add_point(info, buf, buf_end,
> +					&iwe,&probe_resp->rawData[2]);
>   		}
>
>
> @@ -2740,7 +2733,7 @@ static int wireless_get_scan(struct net_device *dev, struct iw_request_info *inf
>   			iwe.u.data.flags |= IW_ENCODE_DISABLED;
>   		}
>
> -		buf = IWE_STREAM_ADD_POINT(info, buf, buf_end,&iwe, NULL);
> +		buf = iwe_stream_add_point(info, buf, buf_end,&iwe, NULL);
>
>
>   		/* Frequency Info */
> @@ -2751,7 +2744,8 @@ static int wireless_get_scan(struct net_device *dev, struct iw_request_info *inf
>   		iwe.u.freq.m = wl_parse_ds_ie( probe_resp );
>   		iwe.u.freq.e = 0;
>
> -		buf = IWE_STREAM_ADD_EVENT(info, buf, buf_end,&iwe, IW_EV_FREQ_LEN);
> +		buf = iwe_stream_add_event(info, buf, buf_end,
> +					&iwe, IW_EV_FREQ_LEN);
>
>
>   		/* Custom info (Beacon Interval) */
> @@ -2762,7 +2756,7 @@ static int wireless_get_scan(struct net_device *dev, struct iw_request_info *inf
>   		sprintf( msg, "beacon_interval=%d", probe_resp->beaconInterval );
>   		iwe.u.data.length = strlen( msg );
>
> -		buf = IWE_STREAM_ADD_POINT(info, buf, buf_end,&iwe, msg);
> +		buf = iwe_stream_add_point(info, buf, buf_end,&iwe, msg);
>
>
>   		/* Custom info (WPA-IE) */
> @@ -2778,7 +2772,8 @@ static int wireless_get_scan(struct net_device *dev, struct iw_request_info *inf
>   			sprintf( msg, "wpa_ie=%s", wl_print_wpa_ie( wpa_ie, wpa_ie_len ));
>   			iwe.u.data.length = strlen( msg );
>
> -			buf = IWE_STREAM_ADD_POINT(info, buf, buf_end,&iwe, msg);
> +			buf = iwe_stream_add_point(info, buf, buf_end,
> +						&iwe, msg);
>   		}
>
>   		/* Add other custom info in formatted string format as needed... */

