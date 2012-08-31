Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab2HaT5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 15:57:23 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53001 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836Ab2HaT5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 15:57:21 -0400
Date: Fri, 31 Aug 2012 15:57:19 -0400 (EDT)
Message-Id: <20120831.155719.2228399422573401952.davem@davemloft.net>
To: swhiteho@redhat.com
Cc: xi.wang@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] decnet: fix shutdown parameter checking
From: David Miller <davem@davemloft.net>
In-Reply-To: <1346059001.2703.7.camel@menhir>
References: <1346035027-2347-1-git-send-email-xi.wang@gmail.com>
	<1346059001.2703.7.camel@menhir>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>
Date: Mon, 27 Aug 2012 10:16:41 +0100

> On Sun, 2012-08-26 at 22:37 -0400, Xi Wang wrote:
>> The allowed value of "how" is SHUT_RD/SHUT_WR/SHUT_RDWR (0/1/2),
>> rather than SHUTDOWN_MASK (3).
>> 
>> Signed-off-by: Xi Wang <xi.wang@gmail.com>
> Acked-by: Steven Whitehouse <swhiteho@redhat.com>

Applied to net-next.

> Although it could be argued that we should also continue to accept the
> value 3 just in case there is any userland software out there which
> sends that value,

True, but this is a rather standard BSD socket interface with a very
specific small set of legitimate input parameters.  Allowing
deviation, even for compatability for specific protocols, is largely
unwise.
