Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab2IQAid (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:38:33 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46387 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751960Ab2IQAib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:38:31 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:ae16:2dff:fe07:4e83]
In-Reply-To: <1347469140-25069-25-git-send-email-davidb@codeaurora.org>
References: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
	<1347469140-25069-25-git-send-email-davidb@codeaurora.org>
Date: Sun, 16 Sep 2012 17:38:29 -0700
Message-ID: <CAOesGMis=ztd3yomGMppJArp_HP4xOKfkGxFDSYj-MFvoh0AOg@mail.gmail.com>
Subject: Re: [PATCH 24/24] ARM: msm: Allow 8960 and 8660 to compile together
From: Olof Johansson <olof@lixom.net>
To: David Brown <davidb@codeaurora.org>
Cc: Daniel Walker <dwalker@fifo99.com>, Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 12, 2012 at 9:59 AM, David Brown <davidb@codeaurora.org> wrote:
> From: Stephen Boyd <sboyd@codeaurora.org>
>
> Modify the Kconfig to allow the MSM 8660 and MSM 8960 targets to
> compile together in the same build. As long as one of these two
> targets is selected the choice menu used to select which SoC to
> support will be hidden. Deselecting both of these targets will
> reintroduce the choice menu, and allow users to select targets
> that must be compiled in isolation.
>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Signed-off-by: David Brown <davidb@codeaurora.org>
> ---
>  arch/arm/mach-msm/Kconfig | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
> index b2740c8..7902de15 100644
> --- a/arch/arm/mach-msm/Kconfig
> +++ b/arch/arm/mach-msm/Kconfig
> @@ -1,8 +1,12 @@
>  if ARCH_MSM
>
> +comment "Qualcomm MSM SoC Type"
> +       depends on (ARCH_MSM8X60 || ARCH_MSM8960)

This OK for now but will stop scaling pretty quickly.

When you introduce the next SoC to this, please add a new silent
option instead, that the multi-soc-capable configs select and switch
the depends over to that option.


-Olof
