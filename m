Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933502Ab1FBLCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 07:02:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:59169 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933181Ab1FBLCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 07:02:20 -0400
Date: Thu, 2 Jun 2011 12:02:16 +0100
From: Mel Gorman <mgorman@suse.de>
To: Bertil Engelholm <bertil.engelholm@ericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: zone_reclaim is hanging high priority real time user
 pthreads
Message-ID: <20110602110216.GF7306@suse.de>
References: <980E20D8E719A84BBF593FDE6AEC23DA0AEB3CFAA7@ESESSCMS0351.eemea.ericsson.se>
 <20110527104823.GA5118@suse.de>
 <980E20D8E719A84BBF593FDE6AEC23DA0AEB42A245@ESESSCMS0351.eemea.ericsson.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <980E20D8E719A84BBF593FDE6AEC23DA0AEB42A245@ESESSCMS0351.eemea.ericsson.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 01:22:42PM +0200, Bertil Engelholm wrote:
> Thanx for the response. Since a few days back we have tried disabling the 
> zone reclaim and the system behaves much better so that seems to be the
> short term solution we'll go for.

Good news.

> I also assume that if you have real time pthreads that are sensitive to 
> stalls you might have to disable zone reclaim also in later kernels
> even though the zone reclaim implementation have been radically improved.
> 

It'd be one possibility. However, I understand that at least one person
is considering adding an additional level of watermarks that is
dependant on the number of real-time threads in the system and their
expected usage. The idea would be that latency sensitive applications
would be allowed to use a number of pages between two watermarks were
other users would wake kswapd or enter direct reclaim. I don't know
where that currently stands though.

Thanks.

-- 
Mel Gorman
SUSE Labs
