Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933165Ab1IBJCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 05:02:45 -0400
Received: from exprod5og116.obsmtp.com ([64.18.0.147]:57829 "EHLO
	exprod5og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933135Ab1IBJCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 05:02:43 -0400
Message-ID: <4E609BAF.2020102@ge.com>
Date: Fri, 02 Sep 2011 10:02:39 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Manohar Vanga <manohar.vanga@cern.ch>
CC: gregkh@suse.de, cota@braap.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] staging: vme: add struct vme_dev for VME devices
References: <1314868526-13230-1-git-send-email-manohar.vanga@cern.ch> <1314868526-13230-3-git-send-email-manohar.vanga@cern.ch>
In-Reply-To: <1314868526-13230-3-git-send-email-manohar.vanga@cern.ch>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Sep 2011 08:58:52.0357 (UTC) FILETIME=[8995E750:01CC694E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/11 10:15, Manohar Vanga wrote:
> diff --git a/drivers/staging/vme/vme.h b/drivers/staging/vme/vme.h
> index 4155d8c..d442cce 100644
> --- a/drivers/staging/vme/vme.h
> +++ b/drivers/staging/vme/vme.h
> @@ -91,17 +91,34 @@ extern struct bus_type vme_bus_type;
>  #define VME_SLOT_CURRENT	-1
>  #define VME_SLOT_ALL		-2
>  
> +/**
> + * VME device identifier structure
> + * @bus: The bus ID of the bus the device is on
> + * @slot: The slot this device is plugged into
> + */
>  struct vme_device_id {
>  	int bus;
>  	int slot;
>  };
>  
> +/**
> + * Structure representing a VME device
> + * @id: The ID of the device (currently the bus and slot number)
> + * @bridge: Pointer to the bridge device this device is on
> + * @dev: Internal device structure
> + */
> +struct vme_dev {
> +	struct vme_device_id id;
> +	struct vme_bridge *bridge;
> +	struct device dev;
> +};
> +

I think we can probably merge vme_device_id and vme_dev.

Since we have a pointer to the vme_bridge, the bus number in vme_device_id is
kinda superfluous.

The direction we are heading in makes the slot number far less important, in
some ways it becomes more of an optional information field (in pre-vme64 racks
we probably won't know which slot the device we are bound to is in anyway).
Basically moving from a binding mechanism like PCI to a binding mechanism
closer to ISA, which matches the (widely used, more historic subset) of
capabilites of the VME bus. I think we can just move the slot number to
vme_dev and do away with vme_device_id entirely.

Martyn


-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)1327322748                         | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
