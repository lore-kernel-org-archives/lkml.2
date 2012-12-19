Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab2LSP5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 10:57:48 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:43821 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552Ab2LSP5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 10:57:39 -0500
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Mehar Bajwa <mehar.bajwa@ti.com>
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        M R Swami Reddy <mr.swami.reddy@ti.com>,
        Rajeev Kumar <rajeev-dlh.kumar@st.com>,
        amoderator list <lsa-devel@alsa-project.org>,
        open list <linux-kernel@vger.kernel.org>,
        Moderator list <devicetree-discuss@lists.ozlabs.org>,
        Hari <harik@ti.com>, Mehar Bajwa <mehar.bajwa@ti.com>,
        Mukund <navada@ti.com>
Subject: Re: [PATCH 1/2] ASoC: tlv320aic326x: Support for TI TLV320AIC3262 audio driver
References: <1355233109-14489-1-git-send-email-mehar.bajwa@ti.com>
Date: Wed, 19 Dec 2012 16:50:44 +0100
In-Reply-To: <1355233109-14489-1-git-send-email-mehar.bajwa@ti.com> (Mehar
	Bajwa's message of "Tue, 11 Dec 2012 19:08:29 +0530")
Message-ID: <874nji3usr.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Mehar" == Mehar Bajwa <mehar.bajwa@ti.com> writes:

Hi,

 Mehar> TI TLV320AIC3262 is a flexible, low-power, low-voltage stereo
 Mehar> audio codec with digital microphone inputs and programmable
 Mehar> outputs. It includes powertune capabilities, enhanced
 Mehar> fully-programmable miniDSP, fixed predefined and parameterizable
 Mehar> signal processing blocks, integrated PLL and flexible digital
 Mehar> interfaces.

 Mehar> +	file = devm_kzalloc(codec->dev, PAGE_SIZE, GFP_KERNEL);
 Mehar> +	if (file == NULL)
 Mehar> +		return -ENOMEM;
 Mehar> +
 Mehar> +	snprintf(file, PAGE_SIZE, "%s_fw_v%d.bin", ps_state->dev_name,
 Mehar> +				ps_state->version);
 Mehar> +	file[PAGE_SIZE - 1] = '\0';
 Mehar> +
 Mehar> +	ret = request_firmware_nowait(THIS_MODULE, FW_ACTION_HOTPLUG,
 Mehar> +				file, codec->dev,
 Mehar> +				GFP_KERNEL, codec, aic3262_firmware_load);

What is this firmware, where can it be found and what is it's license?

You seem to be leaking file here.

 Mehar> +	if (ret < 0) {
 Mehar> +		dev_err(codec->dev, "Firmware request failed\n");
 Mehar> +		goto firm_err;
 Mehar> +	}
 Mehar> +
 Mehar> +	return 0;
 Mehar> +firm_err:
 Mehar> +	if (irq_ret)
 Mehar> +		aic3xxx_free_irq(aic3xxx,
 Mehar> +				 AIC3XXX_IRQ_HEADSET_DETECT, codec);
 Mehar> +	destroy_workqueue(aic3262->workqueue);
 Mehar> +work_err:
 Mehar> +	kfree(aic3262->cfw_p);
 Mehar> +	return ret;
 Mehar> +}

-- 
Bye, Peter Korsgaard
