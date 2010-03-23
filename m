Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505Ab0CWEHF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 00:07:05 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45151 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab0CWEHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 00:07:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OqhknVb2IS519DUPKTKUfUzkswDtlnMqPq6jdvJxWBBbYV7QgKA0kzgajSOAPZIBoK
         rAhB88RZmdGI4nyX6bM+z2Fw0n02/lyjHgTIlZ+Wq/Bblq4pmVkvB//7/atWBDmm7dMw
         ztmt0jJ22AeiXQbkcV8TIOxjUeNZhwjG9jJ0o=
Message-ID: <4BA83E70.4060906@gmail.com>
Date: Mon, 22 Mar 2010 21:07:12 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: forcedeth: cat /sys/class/net/eth0/carrier = Invalid argument
References: <4BA7AA92.5040400@gmail.com> <20100322.205144.256859987.davem@davemloft.net>
In-Reply-To: <20100322.205144.256859987.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 08:51 PM, David Miller wrote:
> From: "Justin P. mattock"<justinmattock@gmail.com>
> Date: Mon, 22 Mar 2010 10:36:18 -0700
>
>> I've pushed my kernel from the latest HEAD to 2.6.31
>> and am still seeing:
>> cat /sys/class/net/eth0/carrier
>> cat: carrier: Invalid argument
>>
>> with my other machine using sky2
>> the same results is:
>> cat /sys/class/net/eth0/carrier
>> 0
>>
>> is there anything on this? before I start
>> a bisect.(looking through bugzilla, I couldn't
>> see anything related).
>
> A device is not able to indicate carrier accurately when
> the device is not currently running.
>
> So you will get an -EINVAL until the device is brought up.

ah.. the machine was up and running but nothing was running
(no dhclient, streaming music, etc..)
now
just ran the machine with ethernet,(up and running) and carrier reported 1

>
> The reason is that most drivers don't even probe the link
> or negotiate link speed and flow control until the device
> is brought up.  Many don't even power up the PHY when the
> device is down, in order to save power.
>
> So the behavior you observe is completely expected.
>


cool, this had me confused.

Thanks for the info on this..
(no bisect for this).


Justin P. Mattock
