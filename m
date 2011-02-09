Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094Ab1BIVyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 16:54:20 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39873 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab1BIVyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 16:54:18 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6252"; a="73823202"
From: David Brown <davidb@codeaurora.org>
To: Dima Zavin <dima@android.com>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] msm: Remove arch-specific gpiomux tables
In-Reply-To: <AANLkTimOAOirgH7haDJjf265zdbvoei=f=GGxQEh+5dh@mail.gmail.com>
	(Dima Zavin's message of "Wed, 9 Feb 2011 12:59:33 -0800")
References: <4D4CAB63.4050301@codeaurora.org>
	<AANLkTimOAOirgH7haDJjf265zdbvoei=f=GGxQEh+5dh@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
X-Hashcash: 1:20:110209:dwalker@codeaurora.org::lnKagIh5cBrga7OF:0000000000000000000000000000000000000000EU7
X-Hashcash: 1:20:110209:dima@android.com::rnMFWXHhlEdJl5rA:00T57
X-Hashcash: 1:20:110209:bryanh@codeaurora.org::qkqCyHcP9O2s5Hdc:00000000000000000000000000000000000000000Mzj
X-Hashcash: 1:20:110209:linux@arm.linux.org.uk::Ds2f03OXhNIyMef6:0000000000000000000000000000000000000000RuB
X-Hashcash: 1:20:110209:linux-kernel@vger.kernel.org::IBCLJ2LWB+nVYYjT:0000000000000000000000000000000000Ztr
X-Hashcash: 1:20:110209:rvaswani@codeaurora.org::nF+3p4n6lnfsSiJi:000000000000000000000000000000000000000+Zt
X-Hashcash: 1:20:110209:linux-arm-kernel@lists.infradead.org::+MINZMALTTWAqWiA:00000000000000000000000006we8
X-Hashcash: 1:20:110209:linux-arm-msm@vger.kernel.org::gFQvxorTG95XVn8g:00000000000000000000000000000000G3ca
Date: Wed, 09 Feb 2011 13:54:17 -0800
Message-ID: <8yaei7gq3g6.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09 2011, Dima Zavin wrote:

> I don't like this solution of putting the magicly named array into the
> board file. What if I want multiple boards to be built into the same
> kernel? What if I want multiple tables in case I have different
> revisions of the board?

Especially since there is a push by some to be able to build everything
into a single kernel.

> The more correct way would be to add a function to gpiomux.c to be
> able to apply a list of gpiomux configs, something like:
>
> int msm_gpiomux_config_table(struct msm_gpiomux_cfg *table, int num);

Good idea.  Although, I think a name like msm_gpiomux_add_configs()
might fit better with other namings.

David
