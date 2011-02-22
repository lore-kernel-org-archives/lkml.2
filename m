Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab1BVLWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 06:22:17 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47816 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab1BVLWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 06:22:16 -0500
Message-ID: <4D639C18.9010309@mvista.com>
Date: Tue, 22 Feb 2011 14:20:56 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Subhasish Ghosh <subhasish@mistralsolutions.com>
CC: davinci-linux-open-source@linux.davincidsp.com, sachi@mistralsolutions.com,
        Russell King <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@deeprootsystems.com>, nsekhar@ti.com,
        open list <linux-kernel@vger.kernel.org>, m-watkins@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 12/13] da850: pruss SUART platform specific additions.
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com> <1297435892-28278-13-git-send-email-subhasish@mistralsolutions.com> <4D55860E.3090908@mvista.com> <B2D7D72494BB443F80DA08E22323999B@subhasishg>
In-Reply-To: <B2D7D72494BB443F80DA08E22323999B@subhasishg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 22-02-2011 12:18, Subhasish Ghosh wrote:

> I could not follow your recommendations clearly, are you suggesting this:

> int __init da8xx_register_pruss(struct da8xx_pruss_devices *pruss_device)
> {
> #ifdef CONFIG_SERIAL_PRUSS_SUART_MODULE
> int ret;
>
> ret = clk_add_alias(NULL, "da8xx_pruss_uart.1",
> NULL, &da850_mcasp_device.dev);
> if (ret < 0)
> return ret;
> #endif
> da8xx_pruss_dev.dev.platform_data = pruss_device;
> return platform_device_register(&da8xx_pruss_dev);
> }

    Yes. But still better would be to wrap clk_add_alias() into a function of 
its own (defining it empty if CONFIG_SERIAL_PRUSS_SUART_MODULE is not defined).

WBR, Sergei
