Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab1AJWQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 17:16:34 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60647 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418Ab1AJWQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 17:16:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ifVrOoQvPRfMz6wlryltWEXUPOG3VV5ZJx9hwz6OYRqEYpUE4uPKNrf6NFvEg58xVR
         J+V6rODZewvNbDWgnm55OjgzrBLZ4g9AyYgVExcbzrBP6nEeqyNhQEgVCTCUDFf0y2nI
         8t883CM9v8Luv2N/BQ0+huwhM/q5l5VhUxovc=
Date: Mon, 10 Jan 2011 14:16:24 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: riyer@nvidia.com
Cc: jj@chaosbits.net, tsoni@codeaurora.org, shubhrajyoti@ti.com,
        ccross@android.com, konkers@android.com, olof@lixom.net,
        achew@nvidia.com, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH v3] input: tegra-kbc - Add tegra keyboard driver
Message-ID: <20110110221624.GA16445@core.coreip.homeip.net>
References: <1294422307-19107-1-git-send-email-riyer@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294422307-19107-1-git-send-email-riyer@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rakesh,

On Fri, Jan 07, 2011 at 09:45:07AM -0800, riyer@nvidia.com wrote:
> +
> +struct tegra_kbc {
> +	void __iomem *mmio;
> +	struct input_dev *idev;
> +	int irq;
> +	unsigned int wake_enable_rows;
> +	unsigned int wake_enable_cols;
> +	spinlock_t lock;
> +	unsigned int repoll_time;
> +	unsigned long cp_dly_jiffies;
> +	int fifo[KBC_MAX_KPENT];
> +	const struct tegra_kbc_platform_data *pdata;
> +	int *plain_keycode;
> +	int *fn_keycode;

There should not be separate keycodes for FN and normal kys - FN is just
a modifier, like SHIFT or CTRL or ALT are and shoudl be handled in upper
layers.

Also you should wire up keycode/keycodemax/keycodesize in input_dev
structuire so that keymap can be retrieved via EVIOCGKEYCODE and
modified via EVIOGSKEYCODE. Also, because keymap is modifiable, the
original keymap should be copied in per-device structure, leaving
original intact. It (the original) also should be marked as const.

Since this papears to be a matrix keypad consider using definitions from
linux/input/matrix_keypad.h

Thank you.

-- 
Dmitry
