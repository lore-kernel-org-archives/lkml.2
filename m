Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759883Ab0JVT31 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:29:27 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:37844 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758562Ab0JVT3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 15:29:22 -0400
X-Sasl-enc: Kglc2+62vud7UKaTYA46VsWOjPpKDafuUYGVEkt0Ev8T 1287775761
Message-ID: <4CC1E610.4050605@fastmail.fm>
Date: Fri, 22 Oct 2010 20:29:20 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-GB; rv:1.9.2.11) Gecko/20101013 Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
        Florian Fainelli <florian@openwrt.org>, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, 600155@bugs.debian.org,
        Jason Heeris <jason.heeris@gmail.com>,
        David Miller <davem@davemloft.net>, spamalot@hispeed.ch,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [11/17] r6040: Fix multicast list iteration when hash filter
 is used
References: <20101022184033.486292826@clark.site> <4CC1E257.4070704@fastmail.fm> <20101022192350.GA10673@suse.de>
In-Reply-To: <20101022192350.GA10673@suse.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/10/2010 20:23, Greg KH wrote:
> On Fri, Oct 22, 2010 at 08:13:27PM +0100, Jack Stone wrote:
>> On 22/10/2010 19:39, Greg KH wrote:
>>>  drivers/net/r6040.c |    1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> --- a/drivers/net/r6040.c
>>> +++ b/drivers/net/r6040.c
>>> @@ -976,6 +976,7 @@ static void r6040_multicast_list(struct
>>>  		iowrite16(hash_table[3], ioaddr + MAR3);
>>>  	}
>>>  	/* Multicast Address 1~4 case */
>>> +	dmi = dev->mc_list;
>>>  	for (i = 0, dmi; (i < dev->mc_count) && (i < MCAST_MAX); i++) {
>> Any reason for the dmi in the above line? As far as I can see it is a
>> nop.
> 
> Look closer at the for loop please.

Maybe I'm missing something but:
for (i = 0, ---->dmi <----; (i < ...

The dmi here still doesn't seem to do anything?

Thanks,

Jack
