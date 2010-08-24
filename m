Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab0HXTuD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 15:50:03 -0400
Received: from smtp.srv.ualberta.ca ([129.128.5.19]:62998 "EHLO
	mail4.srv.ualberta.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752803Ab0HXTuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 15:50:00 -0400
Date: Tue, 24 Aug 2010 13:49:14 -0600 (Mountain Daylight Time)
From: Marc Aurele La France <tsi@ualberta.ca>
To: Ben Hutchings <bhutchings@solarflare.com>
cc: Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: MTU for serving NFS on Infiniband
In-Reply-To: <1282672647.2302.15.camel@achroite.uk.solarflarecom.com>
Message-ID: <alpine.WNT.2.00.1008241338470.1132@cluij.ucs.ualberta.ca>
References: <alpine.LNX.2.00.1008230842290.9325@abcyxhiz.aict.ualberta.ca> <20100823080543.319143e3@nehalam> <alpine.WNT.2.00.1008240856170.2000@cluij.ucs.ualberta.ca> <1282672647.2302.15.camel@achroite.uk.solarflarecom.com>
User-Agent: Alpine 2.00 (WNT 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010, Ben Hutchings wrote:
> On Tue, 2010-08-24 at 09:14 -0600, Marc Aurele La France wrote:
>> On Mon, 23 Aug 2010, Stephen Hemminger wrote:
>>> On Mon, 23 Aug 2010 08:44:37 -0600 (MDT)
>>> Marc Aurele La France <tsi@ualberta.ca> wrote:
>>>> In regrouping for my next tack at this, I noticed that all stack traces go
>>>> through ip_append_data().  This would be ipv6_append_data() in the IPv6 case.
>>>> A _very_ rough draft that would have ip_append_data() temporarily drop down
>>>> to a smaller fake MTU follows ...

>>> Why doesn't NFS generate page size fragments?  Does Infiniband or your
>>> device not support this?  Any thing that requires higher order allocation
>>> is going to unstable under load.  Let's fix the cause not the apply bandaid
>>> solution to the symptom.

>> From what I can tell, IP fragmentation is done centrally.
> [...]

> Stephen and I are not talking about IP fragmentation, but about the
> ability to append 'fragments' to an skb rather than putting the entire
> packet payload in a linear buffer.  See
> <http://vger.kernel.org/~davem/skb_data.html>.

Any payload has to either fit in the MTU, or has to be broken up into 
MTU-sized (or less) fragments, come hell or high water.  That this is done 
centrally is a good thing.  It is the "(or less)" part that I am working 
towards here.

Marc.

+----------------------------------+----------------------------------+
|  Marc Aurele La France           |  work:   1-780-492-9310          |
|  Academic Information and        |  fax:    1-780-492-1729          |
|    Communications Technologies   |  email:  tsi@ualberta.ca         |
|  352 General Services Building   +----------------------------------+
|  University of Alberta           |                                  |
|  Edmonton, Alberta               |    Standard disclaimers apply    |
|  T6G 2H1                         |                                  |
|  CANADA                          |                                  |
+----------------------------------+----------------------------------+
