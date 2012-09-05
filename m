Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221Ab2IEIi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 04:38:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156Ab2IEIiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 04:38:55 -0400
Subject: Re: [PATCH] decnet: fix shutdown parameter checking
From: Steven Whitehouse <swhiteho@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: xi.wang@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20120831.155719.2228399422573401952.davem@davemloft.net>
References: <1346035027-2347-1-git-send-email-xi.wang@gmail.com>
	 <1346059001.2703.7.camel@menhir>
	 <20120831.155719.2228399422573401952.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Wed, 05 Sep 2012 09:37:56 +0100
Message-ID: <1346834276.2799.4.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2012-08-31 at 15:57 -0400, David Miller wrote:
> From: Steven Whitehouse <swhiteho@redhat.com>
> Date: Mon, 27 Aug 2012 10:16:41 +0100
> 
> > On Sun, 2012-08-26 at 22:37 -0400, Xi Wang wrote:
> >> The allowed value of "how" is SHUT_RD/SHUT_WR/SHUT_RDWR (0/1/2),
> >> rather than SHUTDOWN_MASK (3).
> >> 
> >> Signed-off-by: Xi Wang <xi.wang@gmail.com>
> > Acked-by: Steven Whitehouse <swhiteho@redhat.com>
> 
> Applied to net-next.
> 
> > Although it could be argued that we should also continue to accept the
> > value 3 just in case there is any userland software out there which
> > sends that value,
> 
> True, but this is a rather standard BSD socket interface with a very
> specific small set of legitimate input parameters.  Allowing
> deviation, even for compatability for specific protocols, is largely
> unwise.

Yes, I'd agree on the whole, and certainly if this was a recent
addition. However since this code has been around for somewhere close to
16 years now, I'd say that means that either (a) nobody calls shutdown
for DECnet or (b) existing users are buggy too.

We do have a precedent for this kind of compatibility, such as the AX.25
use of SOCK_SEQPACKET.

However, I'm not overly worried and we'll soon know if it will cause any
problems or not,

Steve.



