Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab1FHGx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 02:53:29 -0400
Received: from mailgw10.se.ericsson.net ([193.180.251.61]:62181 "EHLO
	mailgw10.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab1FHGx2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 02:53:28 -0400
X-AuditID: c1b4fb3d-b7c17ae00000262e-7f-4def1c66e66a
From: Bertil Engelholm <bertil.engelholm@ericsson.com>
To: Mel Gorman <mgorman@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 8 Jun 2011 08:53:24 +0200
Subject: RE: PROBLEM: zone_reclaim is hanging high priority real time user
 pthreads
Thread-Topic: PROBLEM: zone_reclaim is hanging high priority real time user
 pthreads
Thread-Index: AcwhFIu9An7zRZswRlCeattEUz+fXQEkk5Kw
Message-ID: <980E20D8E719A84BBF593FDE6AEC23DA0AEB4B84E9@ESESSCMS0351.eemea.ericsson.se>
References: <980E20D8E719A84BBF593FDE6AEC23DA0AEB3CFAA7@ESESSCMS0351.eemea.ericsson.se>
 <20110527104823.GA5118@suse.de>
 <980E20D8E719A84BBF593FDE6AEC23DA0AEB42A245@ESESSCMS0351.eemea.ericsson.se>
 <20110602110216.GF7306@suse.de>
In-Reply-To: <20110602110216.GF7306@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunally the users have now got a problem with zone reclaim disabled.
This time it's a pthread that seems to be stalling for more than 30 seconds !!
We had seen this problem before but I was hoping that disabling zone reclaim
would solve this as well.

I have not had the time to do some trouble shooting yet so I'm kind of hoping
that someone can give some tips what can cause such long stalling. It's not
everything that is stalling, other pthreads that detect this hanging pthread 
are allowed to execute. So the behaviour looks the same as when zone reclaim
hijacked our pthreads. So there seems to be more kernel functions working in 
the same way. The question is what it can be that takes such a long time ?

/Bertil

-----Original Message-----
From: Mel Gorman [mailto:mgorman@suse.de] 
Sent: den 2 juni 2011 13:02
To: Bertil Engelholm
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: zone_reclaim is hanging high priority real time user pthreads

On Fri, May 27, 2011 at 01:22:42PM +0200, Bertil Engelholm wrote:
> Thanx for the response. Since a few days back we have tried disabling 
> the zone reclaim and the system behaves much better so that seems to 
> be the short term solution we'll go for.

Good news.

> I also assume that if you have real time pthreads that are sensitive 
> to stalls you might have to disable zone reclaim also in later kernels 
> even though the zone reclaim implementation have been radically improved.
> 

It'd be one possibility. However, I understand that at least one person is considering adding an additional level of watermarks that is dependant on the number of real-time threads in the system and their expected usage. The idea would be that latency sensitive applications would be allowed to use a number of pages between two watermarks were other users would wake kswapd or enter direct reclaim. I don't know where that currently stands though.

Thanks.

--
Mel Gorman
SUSE Labs
