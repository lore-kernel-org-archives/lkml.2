Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab2LRQdQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 11:33:16 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:34662 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab2LRQdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 11:33:14 -0500
Message-ID: <50D09AC7.9050503@wwwdotorg.org>
Date: Tue, 18 Dec 2012 09:33:11 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: balbi@ti.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb: phy: tegra: Using devm API for memory allocation
References: <1355811683-29981-1-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1355811683-29981-1-git-send-email-vbyravarasu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2012 11:21 PM, Venu Byravarasu wrote:
> Using devm_kzalloc for allocating memory needed for PHY
> pointer and hence removing kfree calls to PHY pointer.

Since the kfree() here used to be in tegra_usb_phy_close() rather than
any remove() function, does it actually make sense to use
devm_kzalloc(); would plain using kzalloc() instead, and not removing
the kfree() calls, be better?

When the PHY code gets converted to be an actual probed driver, then
perhaps using devm will make sense.
