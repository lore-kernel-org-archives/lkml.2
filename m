Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab2LSNCE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 08:02:04 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:45754 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab2LSNB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 08:01:57 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] serial: tegra: add serial driver
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, alan@linux.intel.com,
        gregkh@linuxfoundation.org, jslaby@suse.cz, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-tegra@vger.kernel.org
In-Reply-To: <50CF8F36.2030309@wwwdotorg.org>
References: <1355746249-15347-1-git-send-email-ldewangan@nvidia.com> <20121217171027.6AE573E0BDD@localhost> <50CF8F36.2030309@wwwdotorg.org>
Date: Wed, 19 Dec 2012 13:01:51 +0000
Message-Id: <20121219130151.F29CA3E0AD7@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2012 14:31:34 -0700, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 12/17/2012 10:10 AM, Grant Likely wrote:
> > On Mon, 17 Dec 2012 17:40:49 +0530, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> >> Nvidia's Tegra has multiple uart controller which supports:
> >> - APB dma based controller fifo read/write.
> >> - End Of Data interrupt in incoming data to know whether end
> >>   of frame achieve or not.
> >> - Hw controlled RTS and CTS flow control to reduce SW overhead.
> 
> >> +static int __devinit tegra_uart_probe(struct platform_device *pdev)
> >> +{
> >> +	struct tegra_uart_port *tup;
> >> +	struct uart_port *u;
> >> +	struct tegra_uart_platform_data *pdata = pdev->dev.platform_data;
> > 
> > Since this is a new driver, and all new board support will use device
> > tree, when would this platform_data pointer get set? Can you drop the
> > platform_data support code entirely?
> 
> Aren't we still supposed to support platform data so that it can
> override what's in DT in order to fix up bad DTs? Or, has that
> requirement been dropped. If it has, we can drop a bunch of code from a
> variety of Tegra-specific drivers, I expect.

Do you have an actual user for this? If not, then don't borrow trouble.
Just drop it. Things like platform_data can always be added later only
if it is needed.

g.

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
