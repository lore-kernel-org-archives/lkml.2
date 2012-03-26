Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab2CZLcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 07:32:33 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:45461 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932287Ab2CZLcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 07:32:32 -0400
X-RZG-AUTH: :IW0NeWC7b/q2i6W/qstXb1SBUuFnrGohdvpEkce+Ub4+ReKfHD+mCPEMrYFUgQ==
X-RZG-CLASS-ID: mo05
From: Stefan Roese <sr@denx.de>
To: Viresh Kumar <viresh.kumar@st.com>
Subject: Re: [PATCH] rtc/spear: Add Device Tree probing capability
Date: Mon, 26 Mar 2012 13:32:01 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38-13-generic; KDE/4.7.2; x86_64; ; )
Cc: akpm@linux-foundation.org, devicetree-discuss@lists.ozlabs.org,
        rajeev-dlh.kumar@st.com, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, a.zummo@towertech.it,
        spear-devel@list.st.com, viresh.linux@gmail.com,
        Rob Herring <robherring2@gmail.com>
References: <8747a4b3bdcfb7b3384c14ca909228e1164d0fc5.1332755275.git.viresh.kumar@st.com>
In-Reply-To: <8747a4b3bdcfb7b3384c14ca909228e1164d0fc5.1332755275.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203261332.02073.sr@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 March 2012 11:54:22 Viresh Kumar wrote:
> SPEAr platforms now support DT and so must convert all drivers support DT.
> This patch adds DT probing support for rtc and updates its documentation
> too.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> ---
>  Documentation/devicetree/bindings/rtc/spear-rtc.txt |   18
> ++++++++++++++++++ drivers/rtc/rtc-spear.c                             |  
> 10 ++++++++++ 2 files changed, 28 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rtc/spear-rtc.txt
> 
> diff --git a/Documentation/devicetree/bindings/rtc/spear-rtc.txt
> b/Documentation/devicetree/bindings/rtc/spear-rtc.txt new file mode 100644
> index 0000000..928410f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/rtc/spear-rtc.txt
> @@ -0,0 +1,18 @@
> +* SPEAr RTC
> +
> +Required properties:
> +- compatible : "st,spear-rtc"
> +- reg : Address range of the rtc registers
> +- interrupt-parent: Should be the phandle for the interrupt controller
> +  that services interrupts for this device
> +- interrupt: Should contain the rtc interrupt number
> +
> +Example:
> +
> +	rtc@fc000000 {
> +		compatible = "st,spear-rtc";

With Rob's comments in mind, wouldn't it be better to use a more specific 
compatible property? Should we stick with "st,spear600-rtc"? Or use "st-
spear300-rtc" as "oldest" SoC variant?

Thanks,
Stefan
