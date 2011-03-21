Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab1CUNlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 09:41:40 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51223 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab1CUNlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 09:41:37 -0400
Message-ID: <4D87552D.4070205@ru.mvista.com>
Date: Mon, 21 Mar 2011 16:39:57 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Carl Vanderlip <carlv@codeaurora.org>
CC: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-fbdev@vger.kernel.org,
        Brian Swetland <swetland@google.com>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Dima Zavin <dima@android.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 17/20] video: msm: Prevent framebuffer glitch during	initialization
References: <1300484846-26393-1-git-send-email-carlv@codeaurora.org> <1300485574-27600-1-git-send-email-carlv@codeaurora.org>
In-Reply-To: <1300485574-27600-1-git-send-email-carlv@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Carl Vanderlip wrote:

> Holds a reference to the mdp_clk until lateinit, and moves the frambuffer
> initialization to device_init.

    Maybe I'm just blind but I don't see where the patch does the latter...

> The framebuffer lcdc driver will grab a
> reference to mdp_clk, which prevents the clock from being disabled by
> clock_late_init.

> Authors:
> Dima Zavin <dima@android.com>
> Rebecca Schultz Zavin <rebecca@android.com>
> Colin Cross <ccross@android.com>

> Signed-off-by: Carl Vanderlip <carlv@codeaurora.org>
> ---
>  drivers/video/msm/mdp.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)

> diff --git a/drivers/video/msm/mdp.c b/drivers/video/msm/mdp.c
> index 0bb19fa..b3f334ad 100644
> --- a/drivers/video/msm/mdp.c
> +++ b/drivers/video/msm/mdp.c
> @@ -38,6 +38,7 @@ struct class *mdp_class;
>  
>  static DECLARE_WAIT_QUEUE_HEAD(mdp_ppp_waitqueue);
>  static unsigned int mdp_irq_mask;
> +struct clk *mdp_clk_to_disable_later;

    Why not just 'mdp_clk'? :-)

WBR, Sergei
