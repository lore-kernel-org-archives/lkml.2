Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab1F0WV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 18:21:26 -0400
Received: from lucidpixels.com ([72.73.18.11]:34443 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971Ab1F0WUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 18:20:52 -0400
Date: Mon, 27 Jun 2011 18:20:51 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: "Ronciak, John" <john.ronciak@intel.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Subject: RE: [E1000-devel] 2.6.39.2: skb_over_panic: kernel BUG at
 net/core/skbuff.c:127!
In-Reply-To: <D38E8E86660E514AB505863C19C9287C03A525@ORSMSX101.amr.corp.intel.com>
Message-ID: <alpine.DEB.2.02.1106271814200.6721@p34.internal.lan>
References: <alpine.DEB.2.02.1106271742310.6721@p34.internal.lan> <D38E8E86660E514AB505863C19C9287C03A525@ORSMSX101.amr.corp.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 27 Jun 2011, Ronciak, John wrote:

> Sorry to hear of your problem.  Please do not try to relate something that happened on REHL4 to something that is happening in the 2.6.39 .2 kernel.
>
> Is the problem reproducible?  If so, does this happen every time? What interface had what HW associated with it?  The info included below doesn't say.  What in type of traffic was happening on eth2?
>
> Cheers,
> John
>

Hello John,

Not much actually, just regular cable modem network traffic (was not even
utilizing it heavily), vnstat below:

  eth2                                                                     18:11
   ^                                                              r
   |                                                  r           r
   |                                                  r           r
   |                                                  r           r
   |  r                                               r  r        r
   |  r                                               r  r        r  r
   |  r                                               r  r        r  r
   |  r                          r                    r  r  r  r  r  r
   |  r                          r                    r  r  r  r  r  r  r
   |  r                          r                    r  r  r  r  r  r  r
  -+--------------------------------------------------------------------------->
   |  19 20 21 22 23 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18

  h  rx (KiB)   tx (KiB)      h  rx (KiB)   tx (KiB)      h  rx (KiB)   tx (KiB) 
19      89730       8838    03      11249        620    11     126496       9383
20      10972        596    04      43551       1729    12      86326       6513
21      11489        611    05      12159        699    13      47805       3863
22      12073        630    06      12080        712    14      52322       4577
23      12153        654    07      11894        710    15     135715       8618
00      11536        594    08       7392        396    16      75680       6181
01      11159        560    09          0          0    17      33817       3213
02      11564        575    10        759         51    18       4315        190

The most recent crash was at 16:33.

The system crashed earlier too but I had X running so I couldn't get a 
screenshot, there is no serial port on this machine and netconsole does not
work with this type of failure.

It is unfortunately not reproducible, is there any debugging options that
you would recommend I can enable that will expose this bug? I'm up for
anything at this point.

All of this may have started when I added a 4-port Intel NIC:
http://www.intel.com/Assets/PDF/prodbrief/323205.pdf

NIC = Intel Ethernet I340 Server Adatper

But this is just a guess..

Justin.




