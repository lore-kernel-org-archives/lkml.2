Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab2ILIuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 04:50:19 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:41748 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751865Ab2ILIuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 04:50:14 -0400
MIME-Version: 1.0
In-Reply-To: <1346764151-21323-1-git-send-email-gururaja.hebbar@ti.com>
References: <1346764151-21323-1-git-send-email-gururaja.hebbar@ti.com>
From: "S, Venkatraman" <svenkatr@ti.com>
Date: Wed, 12 Sep 2012 14:19:51 +0530
Message-ID: <CANfBPZ-Wb7HE45DTmwsMt-hpJRUevjbjm9-aCR61B4JFULb8Mw@mail.gmail.com>
Subject: Re: [PATCH] mmc: omap_hsmmc: Enable HSPE bit for high speed cards
To: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Cc: linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, cjb@laptop.org, nsekhar@ti.com,
        sudhakar.raj@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 4, 2012 at 6:39 PM, Hebbar, Gururaja <gururaja.hebbar@ti.com> wrote:
> HSMMC IP on AM33xx need a special setting to handle High-speed cards.
> Other platforms like TI81xx, OMAP4 may need this as-well. This depends
> on the HSMMC IP timing closure done for the high speed cards.
>
> From AM335x TRM (SPRUH73F - 18.3.12 Output Signals Generation)
>
> The MMC/SD/SDIO output signals can be driven on either falling edge or
> rising edge depending on the SD_HCTL[2] HSPE bit. This feature allows
> to reach better timing performance, and thus to increase data transfer
> frequency.
>
> There are few pre-requisites for enabling the HSPE bit
> - Controller should support High-Speed-Enable Bit and
> - Controller should not be using DDR Mode and
> - Controller should advertise that it supports High Speed in
>   capabilities register and
> - MMC/SD clock coming out of controller > 25MHz
>

The patch is well written. But then, I don't see a need for a DT
binding for this feature.
By definition, HS implies 25MHz or above, so that check seems to be
redundant as well.
Meanwhile, I'll check with HSPE enabled on OMAP.

Regards,
Venkat.
