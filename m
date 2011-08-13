Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075Ab1HMI3f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 04:29:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56379 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab1HMI3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 04:29:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: David Brown <davidb@codeaurora.org>, Randy Dunlap <rdunlap@xenotime.net>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Alan Cox <alan@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-doc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 2/4] msm_serial: Add devicetree support
Date: Sat, 13 Aug 2011 10:29 +0200
Message-ID: <1434305.ibxmc6q715@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <1313190008-7551-3-git-send-email-davidb@codeaurora.org>
References: <1313190008-7551-1-git-send-email-davidb@codeaurora.org> <1313190008-7551-3-git-send-email-davidb@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:b4iV7R1wKYR9AOiFErFPHsdC9B0Hdfy9gGsDvO4kvdx
 YKxMCVO7Rm7Zo5Utc8LLHhemp+VBFLpvQFd0bRclrw5uLrZY+l
 7Nj5DjqgqxhPT7eegvaUBaIQOHd9RfN5nqaw8BjiCPQgFzCSdW
 QLIL8NrzyJJgdvkyXSdQHspTsLfa4mPI8NHYxDnlP3qMlXql01
 uXhhw4/89+hnDQA8soDPg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 August 2011 16:00:06 David Brown wrote:
> +Required properties:
> +- compatible :
> +       - "qcom,msm-uart"
> +- reg : offset and length of the register set for the device
> +       for the hsuart operating in compatible mode, there should be a
> +       second pair describing the gsbi registers.
> +- interrupts : should contain the uart interrupt.
> +
> +Example:
> +
> +       uart@19c400000 {
> +               compatible = "qcom,msm-hsuart", "qcom,msm-uart";
> +               reg = <0x19c40000 0x1000">,
> +                     <0x19c00000 0x1000">;
> +               interrupts = <195>;
> +       };



> @@ -920,11 +928,17 @@ static int __devexit msm_serial_remove(struct platform_device *pdev)
>         return 0;
>  }
>  
> +static struct of_device_id msm_match_table[] = {
> +       { .compatible = "qcom,msm-hsuart-lite" },
> +       {}
> +};
> +

Hi David,

It looks like you changed the value for the "compatible" property in the
process of making the patch, but did not update all places.

Should it be qcom,msm-hsuart-lite or qcom,msm-hsuart?

	Arnd
