Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759454Ab2JSQ3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 12:29:39 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60723 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759438Ab2JSQ3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 12:29:38 -0400
Message-ID: <50817FEF.70107@wwwdotorg.org>
Date: Fri, 19 Oct 2012 10:29:35 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: balbi@ti.com
CC: Venu Byravarasu <vbyravarasu@nvidia.com>, stern@rowland.harvard.edu,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 resend] USB: PHY: Re-organize Tegra USB PHY driver
References: <1350643085-27294-1-git-send-email-vbyravarasu@nvidia.com> <20121019153555.GC440@arwen.pp.htv.fi>
In-Reply-To: <20121019153555.GC440@arwen.pp.htv.fi>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2012 09:35 AM, Felipe Balbi wrote:
> Hi,
> 
> On Fri, Oct 19, 2012 at 04:08:05PM +0530, Venu Byravarasu wrote:
>> NVIDIA produces several Tegra SoCs viz Tegra20, Tegra30 etc. In
>> order to support USB PHY drivers on these SoCs, existing PHY
>> driver is split into SoC agnostic common USB PHY driver and
>> Tegra20-specific USB phy driver. This will facilitate easy
>> addition and deletion of phy drivers for Tegra SoCs.
>> 
>> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> 
> I was reading this "driver" more closely and I have a bunch of
> questions about it, but the most important of all of them is: "why
> isn't that a real PHY driver ?". It doesn't have a probe()
> function, it doesn't use struct usb_phy to represent the PHY, it
> has a bunch of tegra-specific APIs and we can't let those
> continue.

One question here: If the PHY "driver" API changes, there will need to
be a bunch of ehci-tegra.c changes too. Will you take all those
through the PHY tree? If you expect to do that, then I'd like to
request you also take:

usb: host: tegra remove include of <mach/iomap.h>
http://www.spinics.net/lists/linux-usb/msg72429.html

... since that should get merged before any large changes to
ehci-tegra.c; it's the EHCI equivalent of the PHY patch you already
merged.

(The same request applies to put that into a branch I can pull into
the Tegra tree as a basis for cleanup in the Tegra tree)

Thanks!
