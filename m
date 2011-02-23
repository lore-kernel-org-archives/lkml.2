Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab1BWJtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 04:49:51 -0500
Received: from exprod5og108.obsmtp.com ([64.18.0.186]:43495 "EHLO
	exprod5og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab1BWJtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 04:49:49 -0500
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Feb 2011 04:49:49 EST
Message-ID: <4D64D70A.1060007@ge.com>
Date: Wed, 23 Feb 2011 09:44:42 +0000
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Manohar Vanga <manohar.vanga@cern.ch>
CC: gregkh@suse.de, cota@braap.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: vme: fix bug in vme_register_bridge
References: <1298453209-30821-1-git-send-email-manohar.vanga@cern.ch>
In-Reply-To: <1298453209-30821-1-git-send-email-manohar.vanga@cern.ch>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Feb 2011 09:44:40.0811 (UTC) FILETIME=[4AE473B0:01CBD33E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/02/11 09:26, Manohar Vanga wrote:
> Fix a bug in vme_register_bridge that results in an infinite loop in
> the event that device_register fails.
> 

Good catch!

Acked-by: Martyn Welch <martyn.welch@ge.com>

> Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>
> ---
>  drivers/staging/vme/vme.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
> index 88bf455..e77d6a8 100644
> --- a/drivers/staging/vme/vme.c
> +++ b/drivers/staging/vme/vme.c
> @@ -1364,9 +1364,14 @@ int vme_register_bridge(struct vme_bridge *bridge)
>  	return retval;
>  
>  err_reg:
> +	/*
> +	 * Ignore the failed device and unregister the rest.
> +	 */
> +	i--;
>  	while (i > -1) {
>  		dev = &bridge->dev[i];
>  		device_unregister(dev);
> +		i--;
>  	}
>  	vme_free_bus_num(bridge->num);
>  	return retval;


-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)127322748                          | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
