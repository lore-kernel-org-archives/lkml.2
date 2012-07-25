Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab2GYJLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 05:11:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36013 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab2GYJLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 05:11:03 -0400
MIME-Version: 1.0
In-Reply-To: <1343149145-22927-1-git-send-email-dianders@chromium.org>
References: <CAD=FV=Wa1bCRvLNnFjhht6nvNorm3CRzX5zrn-YDA2Jec1K3Eg@mail.gmail.com>
	<1343149145-22927-1-git-send-email-dianders@chromium.org>
Date: Wed, 25 Jul 2012 10:11:02 +0100
Message-ID: <CAFbHwiQuE75YPBPtOihtX4jOKP31n_mO6pu6VOTQkp9_jhjtRA@mail.gmail.com>
Subject: Re: [PATCH v3] mmc: dw_mmc: Disable low power mode if SDIO interrupts
 are used
From: Will Newton <will.newton@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        James Hogan <james.hogan@imgtec.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, linux-kernel@vger.kernel.org,
        Grant Grundler <grundler@chromium.org>,
        Olof Johansson <olofj@chromium.org>, shashidharh@vayavyalabs.com,
        ki0351.kim@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 5:59 PM, Doug Anderson <dianders@chromium.org> wrote:
> The documentation for the dw_mmc part says that the low power
> mode should normally only be set for MMC and SD memory and should
> be turned off for SDIO cards that need interrupts detected.
>
> The best place I could find to do this is when the SDIO interrupt
> was first enabled.  I rely on the fact that dw_mci_setup_bus()
> will be called when it's time to reenable.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> Changes in v3:
> - Commenting fixes requested by Seungwoon Jeon and Jaehoon Chung.
> - Only pass 'slot' to the low power disable function since whole mmc
>   structure wasn't needed.
>
> Changes in v2:
> - Commenting fixes requested by Grant Grundler.
> - Be extra certain that we don't re-turn on the low power mode in
>   CLKENA in dw_mci_setup_bus() if SDIO interrupts are enabled.
>   There are no known instances of this happening but it's good to be safe.
>
>
>  drivers/mmc/host/dw_mmc.c |   41 ++++++++++++++++++++++++++++++++++++++---
>  1 files changed, 38 insertions(+), 3 deletions(-)

Acked-by: Will Newton <will.newton@imgtec.com>
