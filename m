Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab1J2BFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 21:05:41 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52262 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007Ab1J2BFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 21:05:39 -0400
Message-ID: <4EAB5170.8000407@lwfinger.net>
Date: Fri, 28 Oct 2011 20:05:52 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: kernel-janitors@vger.kernel.org,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] drivers/staging/rtl8712/rtl871x_mlme.c: eliminate
 a null pointer dereference
References: <1319846297-2985-1-git-send-email-julia@diku.dk>
In-Reply-To: <1319846297-2985-1-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2011 06:58 PM, Julia Lawall wrote:
> From: Julia Lawall<julia@diku.dk>
>
> If ibss_wlan is NULL, it is not correct to memcpy into its field.
>
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
>
> //<smpl>
> @r@
> expression E, E1;
> identifier f;
> statement S1,S2,S3;
> @@
>
> if (E == NULL)
> {
>    ... when != if (E == NULL || ...) S1 else S2
>        when != E = E1
> *E->f
>    ... when any
>    return ...;
> }
> else S3
> //</smpl>
>
> Signed-off-by: Julia Lawall<julia@diku.dk>
>
> ---
> I have no idea whether this is the correct fix.

I believe it is. It probably does not matter as I have never hit an oops at this 
location.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>
>   drivers/staging/rtl8712/rtl871x_mlme.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/rtl8712/rtl871x_mlme.c b/drivers/staging/rtl8712/rtl871x_mlme.c
> index ef8eb6c..4277d03 100644
> --- a/drivers/staging/rtl8712/rtl871x_mlme.c
> +++ b/drivers/staging/rtl8712/rtl871x_mlme.c
> @@ -551,7 +551,7 @@ void r8712_survey_event_callback(struct _adapter *adapter, u8 *pbuf)
>   			ibss_wlan = r8712_find_network(
>   						&pmlmepriv->scanned_queue,
>   						pnetwork->MacAddress);
> -			if (!ibss_wlan) {
> +			if (ibss_wlan) {
>   				memcpy(ibss_wlan->network.IEs,
>   					pnetwork->IEs, 8);
>   				goto exit;
>
>

