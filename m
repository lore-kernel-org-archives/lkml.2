Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab2CVSHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 14:07:43 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58511 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab2CVSHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 14:07:39 -0400
Message-ID: <4F6B6A67.7040905@gmail.com>
Date: Thu, 22 Mar 2012 11:07:35 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Karol Lewandowski <k.lewandowsk@samsung.com>
CC: "w.sang@pengutronix.de" <w.sang@pengutronix.de>,
        "hskinnemoen@gmail.com" <hskinnemoen@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Rade Bozic <rade.bozic.ext@nsn.com>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dirk.brandewie@gmail.com" <dirk.brandewie@gmail.com>,
        "bigeasy@linutronix.de" <bigeasy@linutronix.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "Daney, David" <David.Daney@caviumnetworks.com>
Subject: Re: [PATCH 2/2] i2c: Dynamically assign adapter id if it wasn't explictly
 specified
References: <1331900343-6743-1-git-send-email-k.lewandowsk@samsung.com> <1331900343-6743-3-git-send-email-k.lewandowsk@samsung.com> <4F6B4532.7090806@samsung.com> <4F6B5A22.1090204@cavium.com> <4F6B65D0.1030506@samsung.com>
In-Reply-To: <4F6B65D0.1030506@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2012 10:48 AM, Karol Lewandowski wrote:
> On 22.03.2012 17:58, David Daney wrote:
>
[...]

>>>> diff --git a/drivers/i2c/busses/i2c-octeon.c
>>>> b/drivers/i2c/busses/i2c-octeon.c
>>>> index ee139a5..8470232 100644
>>>> --- a/drivers/i2c/busses/i2c-octeon.c
>>>> +++ b/drivers/i2c/busses/i2c-octeon.c
>>>> @@ -581,7 +581,7 @@ static int __devinit octeon_i2c_probe(struct
>>>> platform_device *pdev)
>>>>
>>>>        i2c->adap = octeon_i2c_ops;
>>>>        i2c->adap.dev.parent =&pdev->dev;
>>>> -    i2c->adap.nr = pdev->id>= 0 ? pdev->id : 0;
>>>> +    i2c->adap.nr = pdev->id;
>>
>> I guess the OCTEON bit seems sane enough.  I don't fully understand why
>> this needs changing, because OCTEON platform code always passes a
>> non-negative pdev->id.
>
>
> i2c controllers instantiated from device tree seem to have -1 as id.
> Thus, trying to register more than one controller will fail as both
> will try to register on bus 0.
>
> However, I've just found that you got rid of this line altogether and
> switched to dynamic id allocation (i2c_add_adapter() instead of
> _numbered_ variant) in "MIPS: Octeon: Use Device Tree." RFC.
> Found here:
>
>    http://thread.gmane.org/gmane.linux.kernel/1104062
>
> In the light of above my (octeon-)fixup becomes redundant.
>
> Shall I repost this patch without octeon changes or is ok anyway?

My preference would be to omit the OCTEON portion from your patch.  As 
you noted, I plan to blow all that code away in the very near future, 
and the patch is not needed for correctness as far as I can see.

David Daney


>
> Thanks!
>
>>   But since you asked for it:
>>
>> Acked-by: David Daney<david.daney@cavium.com>
>>
