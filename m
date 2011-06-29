Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757843Ab1F2Ulf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 16:41:35 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:60207 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757765Ab1F2Uld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 16:41:33 -0400
Subject: Re: [PATCH] net, wireless: Don't return uninitialized in
 __cfg80211_stop_sched_scan()
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1309379244.4071.7.camel@jlt3.sipsolutions.net>
References: <alpine.LNX.2.00.1106292212110.3747@swampdragon.chaosbits.net>
	 <1309379244.4071.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Jun 2011 23:33:50 +0300
Message-ID: <1309379630.1514.122.camel@cumari>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-29 at 22:27 +0200, Johannes Berg wrote: 
> On Wed, 2011-06-29 at 22:13 +0200, Jesper Juhl wrote:
> > If the 'driver_initiated' function argument to
> > __cfg80211_stop_sched_scan() is not 0 then we'll return an
> > uninitialized 'ret' from the function.
> 
> 'err'. I also dislike the initialisation, can we just replace the
> "return err;" at the end of the function with "return 0;" instead?

Luckily we were never using the return value when passing
driver_initiate =- false.

And I agree with you, there's no use to return err at the end.  Better
to simply return 0.


> Luca, should it maybe be return -ENOENT anyway in the !sched_scan_req
> case?

We could do that.  I had just thought that stopping a scan that is not
running would just be a NOP, but if you prefer to return an error in
that case, I can do it.

-- 
Cheers,
Luca.

