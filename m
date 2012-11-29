Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab2K2Sly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 13:41:54 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:46590 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab2K2Slx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 13:41:53 -0500
Message-ID: <50B7AC6E.4050906@wwwdotorg.org>
Date: Thu, 29 Nov 2012 11:41:50 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Terje Bergstrom <tbergstrom@nvidia.com>, linux-tegra@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC v2 2/8] video: tegra: Add syncpoint wait and interrupts
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <1353935954-13763-3-git-send-email-tbergstrom@nvidia.com> <20121129084400.GA28781@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121129084400.GA28781@avionic-0098.adnet.avionic-design.de>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2012 01:44 AM, Thierry Reding wrote:
> On Mon, Nov 26, 2012 at 03:19:08PM +0200, Terje Bergstrom wrote:

>> diff --git a/drivers/video/tegra/host/host1x/host1x_intr.c
>> b/drivers/video/tegra/host/host1x/host1x_intr.c
> [...]
>> +/* Spacing between sync registers */ +#define REGISTER_STRIDE 4
> 
> Erm... no. The usual way you should be doing this is either make
> the register definitions account for the stride or use accessors
> that apply the stride. You should be doing the latter anyway to
> make accesses. For example:
> 
> static inline void host1x_syncpt_writel(struct host1x *host1x, 
> unsigned long value, unsigned long offset) { writel(value,
> host1x->regs + SYNCPT_BASE + offset); }
> 
> static inline unsigned long host1x_syncpt_readl(struct host1x
> *host1x, unsigned long offset) { return readl(host1x->regs +
> SYNCPT_BASE + offset); }
> 
> Alternatively, if you want to pass the register index instead of
> the offset, you can use just multiply the offset in that function:
> 
> writel(value, host1x->regs + SYNCPT_BASE + (offset << 2));
> 
> The same can also be done with the non-syncpt registers.

It seems like reasonable documentation to replace "<< 2" with "*
REGISTER_STRIDE" here.
