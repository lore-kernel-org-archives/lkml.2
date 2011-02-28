Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab1B1Cg2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 21:36:28 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:17916 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab1B1Cg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 21:36:27 -0500
Date: Mon, 28 Feb 2011 11:36:21 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
Subject: Re: [PATCH V2] sdhci: always use max timeout for xfers
In-reply-to: <20110225200722.GA2192@pengutronix.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Philip Rakity <prakity@marvell.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-id: <4D6B0A25.1060009@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
References: <D8739074-546D-4531-A8E9-23E9F7A33EB5@marvell.com>
 <20110225180248.GA15491@pengutronix.de>
 <9C437661-BFCC-4F73-989E-06589E0D37CA@marvell.com>
 <20110225182206.GC15491@pengutronix.de>
 <62F39533-530F-4DF4-BBC6-AF8E9AB9E751@marvell.com>
 <20110225200722.GA2192@pengutronix.de>
X-OriginalArrivalTime: 28 Feb 2011 02:36:26.0012 (UTC)
 FILETIME=[4BAA05C0:01CBD6F0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think that always use max timeout for xfers is not bed..
But when i have sent the RFC patch, during suspend/resume is appeared some problem.
(when busy-waiting, occurred interrupt..so illegal sequence error is occurred..)
Anyone found same problem when suspend/resume?

So, i think that setting maximum timeout value is not good solution about every case.

Regards,
Jaehoon Chung

Wolfram Sang wrote:
> On Fri, Feb 25, 2011 at 10:49:25AM -0800, Philip Rakity wrote:
>> v2
>>
>> use define for max timeout.  remove subroutine call and just
>> set the register directly
> 
> The generic description goes above the "---" line, the incremental
> history of the patch usually below.
> 
>> v1
>>
>> The card/host controller may sometimes return a value that is
>> too low and cause the h/w to timeout a transfer that would have
>> worked.  Using the maximum value avoids this.
>>
>> Signed-off-by: Philip Rakity <prakity@marvell.com>
> 
> What is there seems ok, but it is not enough yet. The quirks can also go
> from the users.
> 
> After that, it gets even more complicated; after this patch
> 'host->timeout_clk' becomes obsolete which should probably cleaned up in
> a later patch together with host->ops->get_timeout_clk. Hmmmm, that
> needs careful auditing.
> 
> Regards,
> 
>    Wolfram
> 

