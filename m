Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751087Ab2LTG7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 01:59:39 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:54779 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843Ab2LTG7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 01:59:34 -0500
Message-ID: <50D2B741.3090709@ti.com>
Date: Thu, 20 Dec 2012 12:29:13 +0530
From: x0172184 <x0172184@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Peter Korsgaard <jacmet@sunsite.dk>
CC: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        amoderator list <lsa-devel@alsa-project.org>,
        open list <linux-kernel@vger.kernel.org>, Hari <harik@ti.com>,
        Mukund <navada@ti.com>
Subject: Re: [PATCH 1/2] ASoC: tlv320aic326x: Support for TI TLV320AIC3262
 audio driver
References: <1355233109-14489-1-git-send-email-mehar.bajwa@ti.com> <874nji3usr.fsf@dell.be.48ers.dk>
In-Reply-To: <874nji3usr.fsf@dell.be.48ers.dk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 December 2012 09:20 PM, Peter Korsgaard wrote:

> Hi,
>
>   Mehar> TI TLV320AIC3262 is a flexible, low-power, low-voltage stereo
>   Mehar> audio codec with digital microphone inputs and programmable
>   Mehar> outputs. It includes powertune capabilities, enhanced
>   Mehar> fully-programmable miniDSP, fixed predefined and parameterizable
>   Mehar> signal processing blocks, integrated PLL and flexible digital
>   Mehar> interfaces.
>
>   Mehar> +	file = devm_kzalloc(codec->dev, PAGE_SIZE, GFP_KERNEL);
>   Mehar> +	if (file == NULL)
>   Mehar> +		return -ENOMEM;
>   Mehar> +
>   Mehar> +	snprintf(file, PAGE_SIZE, "%s_fw_v%d.bin", ps_state->dev_name,
>   Mehar> +				ps_state->version);
>   Mehar> +	file[PAGE_SIZE - 1] = '\0';
>   Mehar> +
>   Mehar> +	ret = request_firmware_nowait(THIS_MODULE, FW_ACTION_HOTPLUG,
>   Mehar> +				file, codec->dev,
>   Mehar> +				GFP_KERNEL, codec, aic3262_firmware_load);
>
> What is this firmware, where can it be found and what is it's license?

* Firmware is the flattened representation of 'struct aic_project'
   data structure in aic3xxx_cfw.h
* We will release a default firmware for all family of AIC CODECs under GPL
* Any other firmware created by other tools using the
   data structure information in aic3xxx_cfw.h file will be licensed appropriately
   by the creator of such firmware.


>
> You seem to be leaking file here.
>
>   Mehar> +	if (ret < 0) {
>   Mehar> +		dev_err(codec->dev, "Firmware request failed\n");
>   Mehar> +		goto firm_err;
>   Mehar> +	}
>   Mehar> +
>   Mehar> +	return 0;
>   Mehar> +firm_err:
>   Mehar> +	if (irq_ret)
>   Mehar> +		aic3xxx_free_irq(aic3xxx,
>   Mehar> +				 AIC3XXX_IRQ_HEADSET_DETECT, codec);
>   Mehar> +	destroy_workqueue(aic3262->workqueue);
>   Mehar> +work_err:
>   Mehar> +	kfree(aic3262->cfw_p);
>   Mehar> +	return ret;
>   Mehar> +}
>
Thanks for you comments,

I will fix File Leaking.


Regards,
Mehar
