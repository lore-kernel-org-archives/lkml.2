Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab1GDVZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 17:25:01 -0400
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:41620 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab1GDVZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 17:25:00 -0400
X-SENDER-IP: [85.230.173.76]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AshyAJIvEk5V5q1MPGdsb2JhbABTiQqPf45yCwEBAQE3Moh8wU0OhigElzyDEIgi
X-IronPort-AV: E=Sophos;i="4.65,475,1304287200"; 
   d="scan'208";a="205397599"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 4 Jul 2011 23:26:40 +0200
To: djkurtz@chromium.org
Cc: dmitry.torokhov@gmail.com, chase.douglas@canonical.com,
        rubini@cvml.unipv.it, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, derek.foreman@collabora.co.uk,
        daniel.stone@collabora.co.uk, olofj@chromium.org
Subject: Re: [PATCH 07/12] Input: synaptics - rename synaptics_data.mt to agm
Message-ID: <20110704212640.GD23915@polaris.bitmath.org>
References: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
 <1309324042-22943-8-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309324042-22943-8-git-send-email-djkurtz@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 01:07:17PM +0800, djkurtz@chromium.org wrote:
> From: Daniel Kurtz <djkurtz@chromium.org>
> 
> Rename the synaptics_data.mt field to priv->agm to indicate it is the
> hardware state reported in a synaptics AGM packet.
> 
> When a Synaptics touchpad is in "AGM" mode, and multiple fingers are
> detected, the touchpad sends alternating "Advanced Gesture Mode" (AGM) and
> "Simple Gesture Mode" (SGM) packets.
>   The AGM packets have w=2, and contain reduced resolution finger data.
>   The SGM packets have w={0,1} and contain full resolution finger data.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---

How about just modifying the comment, i.e., leaving this hunk?

> @@ -147,7 +147,7 @@ struct synaptics_data {
>  
>  	struct serio *pt_port;			/* Pass-through serio port */
>  
> -	struct synaptics_hw_state mt;		/* current gesture packet */
> +	struct synaptics_hw_state agm;		/* last AGM packet */
>  };
>  
>  void synaptics_module_init(void);
> -- 

Thanks,
Henrik
