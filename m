Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab2ENJBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 05:01:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47687 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863Ab2ENJBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 05:01:14 -0400
Message-ID: <4FB0C9D4.2060409@linaro.org>
Date: Mon, 14 May 2012 17:01:08 +0800
From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@freescale.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Richard Zhao <richard.zhao@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Richard Zhao <richard.zhao@freescale.com>, sameo@linux.intel.com,
        shawn.guo@linaro.org
Subject: Re: [PATCH 2/2] mfd: anatop: permit adata be NULL when access register
References: <1336870794-6351-1-git-send-email-richard.zhao@freescale.com> <1336870794-6351-2-git-send-email-richard.zhao@freescale.com> <20120514035137.GB20367@S2100-06.ap.freescale.net> <20120514080835.GB31985@opensource.wolfsonmicro.com> <20120514084810.GD20367@S2100-06.ap.freescale.net>
In-Reply-To: <20120514084810.GD20367@S2100-06.ap.freescale.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012年05月14日 16:48), Shawn Guo wrote:
> On Mon, May 14, 2012 at 09:08:36AM +0100, Mark Brown wrote:
>> On Mon, May 14, 2012 at 11:51:38AM +0800, Shawn Guo wrote:
>>
>>> From what I see, it's reasonable.  Then the immediate question I have
>>> is, should we remove "struct anatop *adata" from anatop_read_reg and
>>> anatop_write_reg completely?
>>
>> Given the way these things tend to go it's probably guaranteeing that
>> your next round of SoCs will have two register compatible anatop blocks :)
> 
> Considering anatop block tends to be a container of misc hardware
> control bits, I haven't really seen any possibility that the future
> SoCs will have multiple anatop blocks.
> 

Hi Shawn,

I think what the concern is we probably don't want several
non-continuous memory blocks of misc hardwares.
If we look into the current registers in anatop, it is really sparse.
Several regulators are using non-continuous address and the thermals are
also using different addresses. If the addresses are continuous then we
don't need the mfd driver.

We've already told Lily Zhang from Freescale and she promises to report
this problem to some inner team.

Yours Sincerely,
Paul
