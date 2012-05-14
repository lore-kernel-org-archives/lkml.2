Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab2ENN1E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 09:27:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53285 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab2ENN1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 09:27:03 -0400
Message-ID: <4FB10821.4000004@linaro.org>
Date: Mon, 14 May 2012 21:26:57 +0800
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
References: <1336870794-6351-1-git-send-email-richard.zhao@freescale.com> <1336870794-6351-2-git-send-email-richard.zhao@freescale.com> <20120514035137.GB20367@S2100-06.ap.freescale.net> <20120514080835.GB31985@opensource.wolfsonmicro.com> <4FB0C9D4.2060409@linaro.org> <20120514094357.GF20367@S2100-06.ap.freescale.net>
In-Reply-To: <20120514094357.GF20367@S2100-06.ap.freescale.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012年05月14日 17:43), Shawn Guo wrote:
> On Mon, May 14, 2012 at 05:01:08PM +0800, Ying-Chun Liu (PaulLiu) wrote:
>> I think what the concern is we probably don't want several
>> non-continuous memory blocks of misc hardwares.
>> If we look into the current registers in anatop, it is really sparse.
>> Several regulators are using non-continuous address and the thermals are
>> also using different addresses. If the addresses are continuous then we
>> don't need the mfd driver.
>>
> I do not quite follow that.  The reason we need mfd driver isn't because
> we do not want to both regulator and thermal drivers to map and access
> the same address on their own which may have synchronization issue?
> 

Not sure about the synchronization issue. But currently thermal driver
in Linaro kernel do map and access the same address on its own now. It
is not a device driver yet and just access the address directly and
work. It seems to me that each different type of misc devices in Anatop
just work alone.

So let's go back to the patch. Why do we need this modification? Anatop
thermal driver can be written as a device driver and don't need this
patch. And we might get benefits when thermal driver written in this
way. Especially some boards do not have a correct fuse data. Any real
use cases of this patch?

Yours Sincerely,
Paul
