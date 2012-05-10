Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478Ab2EJHIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 03:08:17 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44788 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168Ab2EJHIO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 03:08:14 -0400
MIME-Version: 1.0
In-Reply-To: <1336633015.4334.2.camel@jlt3.sipsolutions.net>
References: <cover.1336538937.git.joe@perches.com>
	<20120509.212110.437114897180819434.davem@davemloft.net>
	<1336632528.4334.1.camel@jlt3.sipsolutions.net>
	<1336632860.22495.6.camel@joe2Laptop>
	<1336633015.4334.2.camel@jlt3.sipsolutions.net>
Date: Thu, 10 May 2012 10:08:13 +0300
Message-ID: <CANUX_P3hhiwAdvHqL=SvAwK2oW09RfC5LnanBSvupBROeWhVuw@mail.gmail.com>
Subject: Re: [PATCH 00/13] net: Add and use ether_addr_equal
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Joe Perches <joe@perches.com>, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> >
>> > > That case you didn't convert in mac80211 is probably the
>> > > bug Johannes was talking about which started this whole
>> > > discussion.
>> >
>> > The bug case that started it all is in net/wireless/scan.c and Emmanuel
>> > has since changed it back to memcmp(). Not sure if that's the one you
>> > were referring to or not :-)
>>
>> That's the one that I left alone.
>>
>> Post patch:
>> $ git grep -n -w compare_ether_addr net
>> net/batman-adv/main.h:198: * note: can't use compare_ether_addr() as it requires aligned memory
>> net/wireless/scan.c:381:        return compare_ether_addr(a->bssid, b->bssid);
>
> Ok, great, then that means the fix from Emmanuel won't conflict when it
> gets in.
>

Thanks Joe - as Johannes said this won't conflict with my patch. And
yes the code is now more clear.
