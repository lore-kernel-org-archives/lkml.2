Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab2DQWfP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 18:35:15 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59552 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab2DQWfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 18:35:14 -0400
Message-ID: <4F8DF01D.9040900@wwwdotorg.org>
Date: Tue, 17 Apr 2012 16:35:09 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>, olof@lixom.net
CC: Colin Cross <ccross@android.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 3/3] ARM: dt: tegra_ventana: als and proximity sensor
 isl29018 support
References: <1334645155-13799-1-git-send-email-ldewangan@nvidia.com> <1334645155-13799-4-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1334645155-13799-4-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2012 12:45 AM, Laxman Dewangan wrote:
> Add the device info for ALS and proximity sensor isl29018.

(There were a ton of irrelevant people CC'd on this patch; I cut them
out, but kept the lists in case anyone was interested in the replies.
The most relevant list, linux-tegra, also wasn't CC'd)

> diff --git a/arch/arm/boot/dts/tegra-ventana.dts b/arch/arm/boot/dts/tegra-ventana.dts

> +		/* ALS and proximity sensor */

> +		isl29018: isl29018@44 {

I don't think the label "isl29018:" serves any purpose; nothing else
needs to refer to this node.

I note from http://patchwork.ozlabs.org/patch/132936/ that:

a) Perhaps the vendor prefix should be "isil" not "isl". Olof, can you
please comment here?

b) There's an interrupt signal connected to the device. Can you please
add that, irrespective of whether the driver uses it.

c) This device is also present on Seaboard. Can you update
tegra-seaboard.dts too? You can find the relevant bus from the link above.

Thanks.

> +			compatible = "isl,isl29018";
> +			reg = <0x44>;
> +		};
>  	};
>  
>  	i2c@7000c400 {
