Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab2HVKAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 06:00:08 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33192 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab2HVKAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 06:00:04 -0400
Subject: Re: [PATCH 1/1] tcp: Wrong timeout for SYN segments
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alex Bergmann <alex@linlab.net>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jerry Chu <hkchu@google.com>, Neal Cardwell <ncardwell@google.com>,
        Nandita Dukkipati <nanditad@google.com>
In-Reply-To: <5034A678.3040207@linlab.net>
References: <503419D3.1080700@linlab.net>
	 <1345622798.5158.717.camel@edumazet-glaptop> <50349CC5.3050601@linlab.net>
	 <1345625910.5158.793.camel@edumazet-glaptop> <5034A678.3040207@linlab.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Aug 2012 11:59:57 +0200
Message-ID: <1345629597.5158.924.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-22 at 11:29 +0200, Alex Bergmann wrote:

> Actual 6 SYN frames are sent. The initial one and 5 retries.
> 

first one had a t0 + 0 delay. How can it count ???

> The kernel is waiting another 32 seconds for a SYN+ACK and then gives 
> the ETIMEDOUT back to userspace.
> 
> Do you mean that we have to send another SYN packet after the 3 minutes?
> 

First SYN is not a retransmit

R2 = time_of_last_SYN - time_of_initial_SYN (t0) = 31

If you read RFC it states :

"In particular, R2 for a SYN segment MUST
 be set large enough to provide retransmission of the segment
 for at least 3 minutes."


That means that the last _retransmit_ MUST happen after 180 seconds.

And not :

Send all the restransmits at t0 + 1, then wait 180 seconds before giving
connect() a timeout indication.



