Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab1IOJxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 05:53:20 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:55338 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755479Ab1IOJxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 05:53:18 -0400
Subject: Re: [PATCH] FB: add early fb blank feature.
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Inki Dae <inki.dae@samsung.com>
Cc: FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com
In-Reply-To: <1315544581-16379-1-git-send-email-inki.dae@samsung.com>
References: <1315544581-16379-1-git-send-email-inki.dae@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Sep 2011 12:53:13 +0300
Message-ID: <1316080393.23214.12.camel@deskari>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2011-09-09 at 14:03 +0900, Inki Dae wrote:
> this patch adds early fb blank feature that this is a callback of
> lcd panel driver would be called prior to fb driver's one.
> in case of MIPI-DSI based video mode LCD Panel, for lcd power off,
> the power off commands should be transferred to lcd panel with display
> and mipi-dsi controller enabled because the commands is set to lcd panel
> at vsync porch period. on the other hand, in opposite case, the callback
> of fb driver should be called prior to lcd panel driver's one because of
> same issue. now we could handle call order to fb blank properly.
> 
> the order is as the following:
> 
> at fb_blank function of fbmem.c
>   -> fb_early_notifier_call_chain()
>      -> lcd panel driver's early_set_power()
>   -> info->fbops->fb_blank()
>      -> fb driver's fb_blank()
>   -> fb_notifier_call_chain()
>      -> lcd panel driver's set_power()

I'm not familiar with the lcd.c, so I may be talking nonsense, but I
don't quite understand the need for this patch. If you have some kind of
panel driver, shouldn't the panel driver handle power off in just one
place?

With omapfb and omapdss, the omapfb's fb_blank function just calls power
off in the panel driver, which handles all necessary actions. Is your
model somehow totally different?

 Tomi


