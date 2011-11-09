Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab1KIQai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 11:30:38 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58356 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab1KIQah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 11:30:37 -0500
Message-ID: <4EBAAAA5.7030807@fedoraproject.org>
Date: Wed, 09 Nov 2011 17:30:29 +0100
From: Michel Alexandre Salim <salimma@fedoraproject.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: intel-gfx@lists.freedesktop.org
CC: Keith Packard <keithp@keithp.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] drm/i915: Honor SSC quirk table over the default,
 unless set by user
References: <1320855178.5081.9.camel@fauix11.informatik.uni-erlangen.de>
In-Reply-To: <1320855178.5081.9.camel@fauix11.informatik.uni-erlangen.de>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Additional note: while I've not touched the line since it does not
affect me, it seems that i915_panel_use_ssc *cannot* be less than 0
since that variable is declared as unsigned.

So the last line (the value in dev_priv) will never be used to determine
whether SSC is used anyway. Keith probably knows more since he
introduces that check in the commit that my patch referred to.

On 11/09/2011 05:12 PM, Michel Alexandre Salim wrote:
>  static inline bool intel_panel_use_ssc(struct drm_i915_private *dev_priv)
>  {
> +	if (i915_panel_use_ssc == 1)
> +		return true;
> +	if (dev_priv->quirks & QUIRK_LVDS_SSC_DISABLE)
> +		return false;
>  	if (i915_panel_use_ssc >= 0)
>  		return i915_panel_use_ssc != 0;
> -	return dev_priv->lvds_use_ssc
> -		&& !(dev_priv->quirks & QUIRK_LVDS_SSC_DISABLE);
> +	return dev_priv->lvds_use_ssc;
>  }
>  
>  /**


-- 
Michel Alexandre Salim
µblog:      http://identi.ca/hircus
            http://twitter.com/hircus
GPG key ID: 78884778

()  ascii ribbon campaign - against html e-mail
/\  www.asciiribbon.org   - against proprietary attachments
