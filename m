Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab1ASRoV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 12:44:21 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48560 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab1ASRoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 12:44:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kgh+JKhhJ3dcjxif/wtr3B2u/RaosD2wwjcq7Pu3e9awgOGa/7vdpoWEukhckLkGjv
         mrJgtdZn072K/gnIfI22qNo926HD5Trg+cDCvBkSIl9Jou/HNZ/+VEs+5NfWAX4FjXUE
         O9WdjAdnSLCZ/XVs59AJRjCs2XUAHX5OrIelg=
Date: Wed, 19 Jan 2011 09:44:12 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: tapio.vihuri@nokia.com
Cc: peter.ujfalusi@nokia.com, randy.dunlap@oracle.com,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        ilkka.koskinen@nokia.com, samu.p.onkalo@nokia.com
Subject: Re: [PATCH v4 1/3] ECI: input: introduce ECI accessory input driver
Message-ID: <20110119174412.GB29107@core.coreip.homeip.net>
References: <1295438816-27937-1-git-send-email-tapio.vihuri@nokia.com>
 <1295438816-27937-2-git-send-email-tapio.vihuri@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295438816-27937-2-git-send-email-tapio.vihuri@nokia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tapio,

On Wed, Jan 19, 2011 at 02:06:54PM +0200, tapio.vihuri@nokia.com wrote:
> +
> +	for (; key->type != KE_END; key++) {
> +		switch (key->type) {
> +		case KE_KEY:
> +			__set_bit(key->keycode, eci->acc_input->keybit);
> +			break;
> +		case KE_SW:
> +		case KE_VSW:
> +			__set_bit(key->keycode, eci->acc_input->swbit);
> +			break;
> +		}
> +	}
> +

Is this still needed? I believe sparse_keymap_setup() below shoudl take
care of this...

> +	__set_bit(EV_KEY, eci->acc_input->evbit);
> +	__set_bit(EV_SW, eci->acc_input->evbit);
> +	__set_bit(EV_REP, eci->acc_input->evbit);
> +
> +	err = sparse_keymap_setup(eci->acc_input, eci_keymap, NULL);
> +	if (err)
> +		goto err_free_dev;
> +

Haven't looked at the rest yet...

Thanks.

-- 
Dmitry
