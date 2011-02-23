Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab1BWRBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 12:01:22 -0500
Received: from exprod5og106.obsmtp.com ([64.18.0.182]:35180 "EHLO
	exprod5og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124Ab1BWRBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 12:01:21 -0500
Message-ID: <4D653D4F.8080507@ge.com>
Date: Wed, 23 Feb 2011 17:01:03 +0000
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Manohar Vanga <manohar.vanga@cern.ch>
CC: gregkh@suse.de, wfp5p@virginia.edu, cota@braap.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: vme: fix loop condition
References: <1298467528-26472-1-git-send-email-manohar.vanga@cern.ch> <1298467528-26472-3-git-send-email-manohar.vanga@cern.ch>
In-Reply-To: <1298467528-26472-3-git-send-email-manohar.vanga@cern.ch>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Feb 2011 17:01:01.0785 (UTC) FILETIME=[3FF80C90:01CBD37B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/02/11 13:25, Manohar Vanga wrote:
> Fix loop condition in vme_register_bridge that results in an infinite
> loop in the event that device_register fails.
> 
> Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>

Acked-by: Martyn Welch <martyn.welch@ge.com>

> ---
>  drivers/staging/vme/vme.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
> index 88bf455..c1ec230 100644
> --- a/drivers/staging/vme/vme.c
> +++ b/drivers/staging/vme/vme.c
> @@ -1364,7 +1364,7 @@ int vme_register_bridge(struct vme_bridge *bridge)
>  	return retval;
>  
>  err_reg:
> -	while (i > -1) {
> +	while (--i >= 0) {
>  		dev = &bridge->dev[i];
>  		device_unregister(dev);
>  	}


-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)127322748                          | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
