Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569Ab2DZQYQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 12:24:16 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49974 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757575Ab2DZQYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 12:24:15 -0400
Message-ID: <4F9976AB.1020502@wwwdotorg.org>
Date: Thu, 26 Apr 2012 10:24:11 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Dong Aisheng <b29396@freescale.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linus.walleij@stericsson.com,
        s.hauer@pengutronix.de, shawn.guo@freescale.com, kernel@pengutronix.de,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, cjb@laptop.org,
        b20223@freescale.com
Subject: Re: [PATCH v4 1/4] dt: add of_get_child_count helper function
References: <1335451227-27709-1-git-send-email-b29396@freescale.com>
In-Reply-To: <1335451227-27709-1-git-send-email-b29396@freescale.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2012 08:40 AM, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> Currently most code to get child count in kernel are almost same,
> add a helper to implement this function for dt to use.

> diff --git a/include/linux/of.h b/include/linux/of.h

> +static inline int of_get_child_count(const struct device_node *np)
> +{
> +	struct device_node *child = NULL;

You don't actually need to initialize child here. It doesn't really
matter here, but in a more complex function, it might hide a
used-before-initialized error.
