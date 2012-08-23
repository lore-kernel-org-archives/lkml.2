Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788Ab2HWMve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 08:51:34 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48024 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758490Ab2HWMv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 08:51:29 -0400
Subject: RE: [PATCH 1/1] tcp: Wrong timeout for SYN segments
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Alex Bergmann <alex@linlab.net>, "H.K. Jerry Chu" <hkjerry.chu@gmail.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B6FC3@saturn3.aculab.com>
References: <503419D3.1080700@linlab.net>
	 <CAFbMe2M7ekc94bQk7vTS1LhScPd49VZ-zKOCUXhqwxXtL-nkuA@mail.gmail.com>
	 <50361AEA.6010807@linlab.net> <1345724123.5904.756.camel@edumazet-glaptop>
	 <AE90C24D6B3A694183C094C60CF0A2F6026B6FC3@saturn3.aculab.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Aug 2012 14:51:23 +0200
Message-ID: <1345726283.5904.842.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-23 at 13:35 +0100, David Laight wrote:
> > I would suggest to increase TCP_SYN_RETRIES from 5 to 6.
> > 
> > 180 secs is eternity, but 31 secs is too small.
> 
> Wasn't the intention of the long delay to allow a system
> acting as a router to reboot?
> I suspect that is why it (and some other TCP timers)
> are in minutes.

One could argue that if an application really wants to connect to a
peer, it should probably handle failures and retries.

But for unaware (basic ?) applications, the 3 -> 1 change reduced by a 3
factor the timeout. So a transient network failure has now more
chance to impact them.

Not all applications run inside a browser or under human control...



