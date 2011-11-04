Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab1KDLHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 07:07:54 -0400
Received: from exprod5og108.obsmtp.com ([64.18.0.186]:60124 "EHLO
	exprod5og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab1KDLHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 07:07:53 -0400
Message-ID: <4EB3C657.4080400@ge.com>
Date: Fri, 04 Nov 2011 11:02:47 +0000
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Manohar Vanga <manohar.vanga@cern.ch>
CC: gregkh@suse.de, cota@braap.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] staging: vme: remove vme_add_bus() and vme_remove_bus()
References: <1320401551-29287-1-git-send-email-manohar.vanga@cern.ch> <1320401551-29287-3-git-send-email-manohar.vanga@cern.ch>
In-Reply-To: <1320401551-29287-3-git-send-email-manohar.vanga@cern.ch>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Nov 2011 11:00:37.0205 (UTC) FILETIME=[FBA38050:01CC9AE0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/11 10:12, Manohar Vanga wrote:
> The functions vme_add_bus() and vme_remove_bus() were only being used
> in the vme_register_bridge() and vme_unregister_bridge() functions
> respectively. This patch gets rid of them and moves their code to
> vme_register_bridge() and vme_unregister_bridge().
> 
> Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>

Acked-by: Martyn Welch <martyn.welch@ge.com>

> ---
>  drivers/staging/vme/vme.c |   26 ++++++++------------------
>  1 files changed, 8 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
> index 3cbc69c..4c6dc69 100644
> --- a/drivers/staging/vme/vme.c
> +++ b/drivers/staging/vme/vme.c
> @@ -1307,7 +1307,12 @@ EXPORT_SYMBOL(vme_slot_get);
>  
>  /* - Bridge Registration --------------------------------------------------- */
>  
> -static int vme_add_bus(struct vme_bridge *bridge)
> +static void vme_dev_release(struct device *dev)
> +{
> +	kfree(dev_to_vme_dev(dev));
> +}
> +
> +int vme_register_bridge(struct vme_bridge *bridge)
>  {
>  	int i;
>  	int ret = -1;
> @@ -1327,8 +1332,9 @@ static int vme_add_bus(struct vme_bridge *bridge)
>  
>  	return ret;
>  }
> +EXPORT_SYMBOL(vme_register_bridge);
>  
> -static void vme_remove_bus(struct vme_bridge *bridge)
> +void vme_unregister_bridge(struct vme_bridge *bridge)
>  {
>  	struct vme_dev *vdev;
>  	struct vme_dev *tmp;
> @@ -1343,22 +1349,6 @@ static void vme_remove_bus(struct vme_bridge *bridge)
>  	list_del(&bridge->bus_list);
>  	mutex_unlock(&vme_buses_lock);
>  }
> -
> -static void vme_dev_release(struct device *dev)
> -{
> -	kfree(dev_to_vme_dev(dev));
> -}
> -
> -int vme_register_bridge(struct vme_bridge *bridge)
> -{
> -	return vme_add_bus(bridge);
> -}
> -EXPORT_SYMBOL(vme_register_bridge);
> -
> -void vme_unregister_bridge(struct vme_bridge *bridge)
> -{
> -	vme_remove_bus(bridge);
> -}
>  EXPORT_SYMBOL(vme_unregister_bridge);
>  
>  /* - Driver Registration --------------------------------------------------- */


-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)1327322748                         | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
