Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab1ASW6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 17:58:43 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40929 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab1ASW6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 17:58:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=g+t3d1ewHtf8VLAybBcBsb5ro16UzKrKKbj2AjKlLjqyDPTv37ljziclxVGFac7Eb4
         KixcGRNXIipLLtruMoX3zhvirnils+S8jcSIfWD8McisBjiyL0ZONM/d0OM2CcdWqbDL
         46nPpi1MExCv1/WrBWeKkES45M9taeo/mQdvI=
Date: Wed, 19 Jan 2011 14:58:34 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: riyer@nvidia.com
Cc: tsoni@codeaurora.org, pavel@ucw.cz, shubhrajyoti@ti.com,
        ccross@android.com, konkers@android.com, olof@lixom.net,
        achew@nvidia.com, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH v6] input: tegra-kbc - Add tegra keyboard driver
Message-ID: <20110119225834.GA29284@core.coreip.homeip.net>
References: <1295476207-15331-1-git-send-email-riyer@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295476207-15331-1-git-send-email-riyer@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 02:30:07PM -0800, riyer@nvidia.com wrote:
> +
> +static void tegra_kbc_report_keys(struct tegra_kbc *kbc)
> +{
> +	unsigned char scancodes[KBC_MAX_KPENT];
> +	unsigned short keycodes[KBC_MAX_KPENT];
> +	u32 val = 0;
> +	unsigned int i;
> +	unsigned int num_down = 0;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&kbc->lock, flags);
> +	for (i = 0; i < KBC_MAX_KPENT * 4; i++) {

This will cause going beyond scancodes[] and keycodes[] and stomping on
your stack...

-- 
Dmitry
