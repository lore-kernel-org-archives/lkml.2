Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab0GIGUQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 02:20:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51891
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751411Ab0GIGUO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 02:20:14 -0400
Date: Thu, 08 Jul 2010 23:20:28 -0700 (PDT)
Message-Id: <20100708.232028.15247875.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: torvalds@linux-foundation.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org, kaber@trash.net,
       jengelh@medozas.de, casteyde.christian@free.fr
Subject: Re: 2.6.35-rc4-git3: Reported regressions from 2.6.34
From: David Miller <davem@davemloft.net>
In-Reply-To: <1278653334.2435.196.camel@edumazet-laptop>
References: <AANLkTiknnzWyVpqnPCpyiEVHLgkewd0zaGzLInABRe2G@mail.gmail.com>
	<20100708.213420.112614033.davem@davemloft.net>
	<1278653334.2435.196.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 09 Jul 2010 07:28:54 +0200

> Le jeudi 08 juillet 2010 à 21:34 -0700, David Miller a écrit :
>> From: Linus Torvalds <torvalds@linux-foundation.org>
>> Date: Thu, 8 Jul 2010 18:34:25 -0700
>> 
>> > On Thu, Jul 8, 2010 at 4:33 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >>
>> >> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16187
>> >> Subject         : Carrier detection failed in dhcpcd when link is up
>> >> Submitter       : Christian Casteyde <casteyde.christian@free.fr>
>> >> Date            : 2010-06-12 15:15 (27 days old)
>> >> First-Bad-Commit: http://git.kernel.org/linus/10708f37ae729baba9b67bd134c3720709d4ae62
>> >> Handled-By      : Andrew Morton <akpm@linux-foundation.org>
>> > 
>> > David? This bisects to a networking commit. Doesn't look sensible, but
>> > what do I know?
>> 
>> My suspicion is that dhcpd uses netlink to dump the info of the
>> available links, and due to some bug gets confused with the new 64-bit
>> statistic netlink attribute being there now.
>> a second to have a look at this.
> 
> It could be a dhcpcd bug because of extended size of answer
> 
> According to strace, dhcpcd tries a recvmsg() call with
> a 256 bytes buffer to hold answer.
> 
> Looking at current dhcpcd source, I confirm it cannot realloc its buffer
 ...
> This program needs to fix this.

Agreed, I don't there is any reasonable way we could cater to this
application bug with some compatability bits.  Restricting the link
dump to 256 bytes is just too much inflexibility.

If NetworkManager can get this right, dhcpd very well can too :-)
