Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab1ERWop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 18:44:45 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:62831 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab1ERWoo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 18:44:44 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-131.messagelabs.com!1305758682!9830895!4
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.178]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>
CC: "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 18 May 2011 17:44:39 -0500
Subject: RE: [PATCH 5/7] msm: gpiomux: Move public API to public header
Thread-Topic: [PATCH 5/7] msm: gpiomux: Move public API to public header
Thread-Index: AcwVpgo84/0XOcNfSq23YW6syyRjIAABli3Q
Message-ID: <0D753D10438DA54287A00B027084269764D2F7405A@AUSP01VMBX24.collaborationhost.net>
References: <1305755453-31112-1-git-send-email-davidb@codeaurora.org>
 <1305755453-31112-6-git-send-email-davidb@codeaurora.org>
In-Reply-To: <1305755453-31112-6-git-send-email-davidb@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 18, 2011 2:51 PM, David Brown wrote:
>
> The gpiomux.h header contains some SOC ifdefs.  However, the API that
> is actually used by the GPIO driver only uses two functions that are
> general.  Move these general definitions into a public header file.
>
> Signed-off-by: David Brown <davidb@codeaurora.org>
> ---
>  arch/arm/mach-msm/gpio.c    |    2 +-
>  arch/arm/mach-msm/gpiomux.h |   17 +----------------
>  include/linux/msm_gpiomux.h |   38 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 40 insertions(+), 17 deletions(-)
>  create mode 100644 include/linux/msm_gpiomux.h

The msm_gpiomux.h header appears to be very "msm" specific, especially
with the #ifdef CONFIG_MSM_GPIOMUX in it.  Wouldn't it be cleaner to
just move it to arch/arm/mach-msm/include/mach/msm_gpiomux.h?

I don't see a reason why this header needs/should be available for
the general public in /include/linux.

Regards,
Hartley