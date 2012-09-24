Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab2IXOkM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 10:40:12 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:31757 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776Ab2IXOkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 10:40:10 -0400
Message-ID: <506070C7.9020507@c-s.fr>
Date: Mon, 24 Sep 2012 16:40:07 +0200
From: leroy christophe <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>
CC: David S Miller <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] lxt PHY: Support for the buggy LXT973 rev A2
References: <201209241400.q8OE0w38011790@localhost.localdomain> <AE90C24D6B3A694183C094C60CF0A2F6026B7004@saturn3.aculab.com>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B7004@saturn3.aculab.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 24/09/2012 16:13, David Laight a écrit :
>> This patch adds proper handling of the buggy revision A2 of LXT973 phy, adding
>> precautions linked to ERRATA Item 4:
>>
>> Revision A2 of LXT973 chip randomly returns the contents of the previous even
>> register when you read a odd register regularly
> Does reading the PHY registers involve bit-banging an MII interface?
> If so this code is likely to stall the system for significant
> periods (ready phy registers at all can be a problem).
>
> I know some ethernet mac have hardware blocks for reading MII
> and even polling one MII register for changes.
>
> Maybe some of this code ought to be using async software
> bit-bang - especially when just polling for link status change.
> I'm sure it ought to be possible to do one bit-bang action
> per clock tick instead of spinning for the required delays.
>
> 	David
>
Not sure I understand what you mean. We have been using this code 
without any problem for about 2 years on our Hardware.
It does almost same as genphy_read_status() except that it also reads 
the BMCR register (which is the register preceeding the BMSR) in order 
to detect the unlikely happening of the bug reported by the ERRATA. In 
case it happens (which is really seldom), it does a re-read.
We are not spinning on any delays here.

Christophe
