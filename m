Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab2HTSht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 14:37:49 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41201 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab2HTShr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 14:37:47 -0400
Message-ID: <503283F8.4070808@wwwdotorg.org>
Date: Mon, 20 Aug 2012 12:37:44 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>, "olof@lixom.net" <olof@lixom.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] ARM: dt: tegra: harmony: add regulators
References: <1345186799-18229-1-git-send-email-ldewangan@nvidia.com> <502E9B09.3080800@wwwdotorg.org> <502EA1AC.4090205@wwwdotorg.org> <50327242.80103@nvidia.com> <50327897.5030601@wwwdotorg.org> <20120820175410.GI26991@opensource.wolfsonmicro.com> <50327D2D.6000509@wwwdotorg.org> <20120820181432.GJ26991@opensource.wolfsonmicro.com>
In-Reply-To: <20120820181432.GJ26991@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2012 12:14 PM, Mark Brown wrote:
> On Mon, Aug 20, 2012 at 12:08:45PM -0600, Stephen Warren wrote:
> 
>> The patch in this thread adds all the required regulators to the
>> DT file. However, it should also remove the special case so the 
>> regulators don't get registered twice, once from the board file
>> and once from DT. However, doing that would prevent regulators
>> getting registered at all, since v3.6-rc* don't have all the
>> required (TPS6586x) regulator (driver) patches to get the
>> regulators instantiated from DT. Everything will only work in
>> linux-next or sometime during the 3.7 merge window.  Hence, git
>> bisect would be broken.
> 
>> One solution to this is to bring the regulator tree into the
>> Tegra tree as a dependency, and then apply a patch which adds the
>> regulators to DT, and removes the special case from the board
>> file. I'm asking for your OK to do that.
> 
> Why not just pull the patch in via the regulator tree?  The idea
> of merging the entire regulator drivers branch into the Tegra tree
> doesn't seem awesome...

I think that'd end up causing some annoying conflicts with other
changes that also touch arch/arm/match-tegra/board-dt-tegra20.c.
Perhaps they're manageable; they probably aren't that bad, but it
seems better to avoid them.
