Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758399Ab2AFIJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 03:09:28 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1034 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab2AFIJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 03:09:26 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6580"; a="152717200"
X-IronPort-AV: E=Sophos;i="4.71,465,1320652800"; 
   d="scan'208";a="160661671"
Message-ID: <4F06AC0E.1000809@qca.qualcomm.com>
Date: Fri, 6 Jan 2012 10:08:46 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>
CC: <linville@tuxdriver.com>, <sfr@canb.auug.org.au>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
        <davem@davemloft.net>
Subject: Re: [PATCH v2 4/6] ath6kl: get rid of AR_DBG_LVL_CHECK()
References: <AE90C24D6B3A694183C094C60CF0A2F6D8AF33@saturn3.aculab.com>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6D8AF33@saturn3.aculab.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.64.130.189]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2012 04:14 PM, David Laight wrote:
> 
>> We don't need it as debug calls already have a log level and
>> compiler should be smart enough to optimise away the code when
>> ath6kl debug code is not enabled.
> 
> Have you checked?

No, I just assumed so.

> I think you are assuming that because the called function collapses,
> the call will be removed allowing the loop to be removed. I suspect
> this is only true if the function is inlined. IIRC the normal linkage
> rules mean that only static functions are candidates for inlining.

I think you are right.

But while I investigated more I noticed that ath6kl_dump_registers()
will be an empty static inline whenever CONFIG_ATH6KL_DEBUG is disabled
and that will make sure that the whole function is not included. So
whenever ath6kl debug code is enabled there is a small performance hit,
but it's so small that IMHO we don't need to worry about it.

And for optimal performance CONFIG_ATH6KL_DEBUG should be disabled anyway.

What do you think?

Kalle
