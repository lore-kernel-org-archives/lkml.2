Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965259Ab2LGTwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 14:52:08 -0500
Received: from mail.fuel7.com ([74.222.0.51]:43957 "EHLO mail.fuel7.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632Ab2LGTwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 14:52:07 -0500
Message-ID: <50C248BD.6080803@fuel7.com>
Date: Fri, 07 Dec 2012 13:51:25 -0600
From: Patrick Trantham <patrick.trantham@fuel7.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Cong Ding <dinggnu@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Otavio Salvador <otavio@ossystems.com.br>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Jiri Kosina <jkosina@suse.cz>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix initializer entry defined twice issue
References: <1354835928-617-1-git-send-email-dinggnu@gmail.com> <50C13159.2070901@fuel7.com> <20121207000511.GD2510@gmail.com>
In-Reply-To: <20121207000511.GD2510@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2012 06:05 PM, Cong Ding wrote:
> On Thu, Dec 06, 2012 at 05:59:21PM -0600, Patrick Trantham wrote:
>> On 12/06/2012 05:16 PM, Cong Ding wrote:
>>> the ".config_intr" is defined twice in both line 208 and 212.
>>>
>>> Signed-off-by: Cong Ding <dinggnu@gmail.com>
>>> ---
>>>   drivers/net/phy/smsc.c |    1 -
>>>   1 files changed, 0 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
>>> index 16dceed..5cee6bd 100644
>>> --- a/drivers/net/phy/smsc.c
>>> +++ b/drivers/net/phy/smsc.c
>>> @@ -205,7 +205,6 @@ static struct phy_driver smsc_phy_driver[] = {
>>>   	/* basic functions */
>>>   	.config_aneg	= genphy_config_aneg,
>>>   	.read_status	= lan87xx_read_status,
>>> -	.config_intr	= smsc_phy_config_intr,
>>>   	/* IRQ related */
>>>   	.ack_interrupt	= smsc_phy_ack_interrupt,
>> Hi Cong,
>>
>> That looks like a mistake from my previous patch to that file.  Copy
>> and paste fail.
>>
>> The line should read:
>> .config_init    = smsc_phy_config_init,
>>
>> I can submit a patch once I get off work unless you beat me to it.
> Thanks for the note. It's better that you submit a patch together with your
> code.
>
> - cong

Patch submitted, thanks for pointing this out!

- Patrick
