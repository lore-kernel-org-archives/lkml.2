Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab2ELNsW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 09:48:22 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14022 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab2ELNsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 09:48:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sat, 12 May 2012 06:48:19 -0700
Message-ID: <4FAE6932.7070605@nvidia.com>
Date: Sat, 12 May 2012 19:14:18 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V1 2/2] i2c: tegra: notify transfer-complete after clearing
 status.
References: <1336373179-12739-1-git-send-email-ldewangan@nvidia.com> <1336373179-12739-3-git-send-email-ldewangan@nvidia.com> <20120512130756.GI20673@pengutronix.de>
In-Reply-To: <20120512130756.GI20673@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 May 2012 06:37 PM, Wolfram Sang wrote:
> * PGP Signed by an unknown key
>
> On Mon, May 07, 2012 at 12:16:19PM +0530, Laxman Dewangan wrote:
>> The notification of the transfer complete by calling complete()
>> should be done after clearing all interrupt status.
>> This may avoid the race condition of misconfigure the i2c controller
>> in multi-core environment.
> "may avoid" or "does avoid"? I.e. does it fix any bug that really
> occured? Then I'd add a stable tag.
>
> So far, applied to next.
"does avoid".
We had some of stability issue in long hour stress test with i2c and 
this is one the fix towards the stability issue. Most of fixes are 
already there in the mainline.
It is  fine to stable tag on this change.

>>   	if (status&  I2C_INT_PACKET_XFER_COMPLETE) {
>>   		BUG_ON(i2c_dev->msg_buf_remaining);
>>   		complete(&i2c_dev->msg_complete);
>>   	}
> Side note: If you see a way to handle the BUG invocations more
> gracefully, that would be appreciated.
>
Ok, I will work towards that.

Thanks,
Laxman


