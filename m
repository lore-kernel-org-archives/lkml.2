Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370Ab2LRQzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 11:55:24 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:45801 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235Ab2LRQzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 11:55:20 -0500
Message-ID: <50D09FF5.7050901@wwwdotorg.org>
Date: Tue, 18 Dec 2012 09:55:17 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] ARM: tegra: add connection name for uart clock table
References: <1355746101-15291-1-git-send-email-ldewangan@nvidia.com> <1355746101-15291-3-git-send-email-ldewangan@nvidia.com> <50CF9233.3010506@wwwdotorg.org> <50D015B5.8050805@nvidia.com>
In-Reply-To: <50D015B5.8050805@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2012 12:05 AM, Laxman Dewangan wrote:
> On Tuesday 18 December 2012 03:14 AM, Stephen Warren wrote:
>> On 12/17/2012 05:08 AM, Laxman Dewangan wrote:
>>> Add connection name "uart-clk" for the uart clock information.
>>
>> Does the UART receive more than one clock, so that it actually cares
>> what the clock connection name is? If not, can we just drop this patch?
> 
> I like to have this patch because:
> - In future, I want to also get the name of the clock source and set
> parent of uart clock properly.

I don't understand that; drivers should not care about the names of
clocks; the names will be entirely irrelevant once we get clocks from DT.

> - I want to switch the parent clock source dynamically between CLKM and
> PLLP to achieve more power optimization i.e. use CLKM wherever possible..

I'd prefer to defer that until after we get clocks from DT. Otherwise,
we're just adding more churn to the old clock driver first. It'd be
better to just switch to the new clock driver, put all the clocks in DT,
and then build on that.
