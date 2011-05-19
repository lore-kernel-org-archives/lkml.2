Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab1ESES0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 00:18:26 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:60960 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab1ESESZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 00:18:25 -0400
Date: Thu, 19 May 2011 00:14:26 -0400 (EDT)
Message-Id: <20110519.001426.2119532755281545481.davem@davemloft.net>
To: tsunanet@gmail.com
Cc: kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, hagen@jauu.net,
        eric.dumazet@gmail.com, alexander.zimmermann@comsys.rwth-aachen.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tcp: Implement a two-level initial RTO as per draft
 RFC 2988bis-02.
From: David Miller <davem@davemloft.net>
In-Reply-To: <BANLkTinEN_=jSCw4qR1PqtWaQ+07OMq7tg@mail.gmail.com>
References: <1305771744-83951-1-git-send-email-tsunanet@gmail.com>
	<20110518.223622.1525088601595365235.davem@davemloft.net>
	<BANLkTinEN_=jSCw4qR1PqtWaQ+07OMq7tg@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 18 May 2011 21:14:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: tsuna <tsunanet@gmail.com>
Date: Wed, 18 May 2011 20:56:33 -0700

> On Wed, May 18, 2011 at 7:36 PM, David Miller <davem@davemloft.net> wrote:
>> From: Benoit Sigoure <tsunanet@gmail.com>
>> Date: Wed, 18 May 2011 19:22:24 -0700
>>
>>> Prior to this patch, Linux would always use 3 seconds (compile-time
>>> constant) as the initial RTO.  Draft RFC 2988bis-02 proposes to tune
>>> this down to 1 second and, in case of a timeout during the TCP 3WHS,
>>> revert the RTO back up to 3 seconds when data transmission begins.
>>
>> We just had a discussion where it was determined that changes to
>> these settings are "network specific" and therefore that if it
>> is appropriate at all (I'm still not convinced) it is only suitable
>> as a routing metric.
> 
> Fair enough.  I'll take another stab at it and see if I can change
> this to be on a per network basis.  Do I need any patch that's not yet
> in Linus' tree?  I'm referring to this:

Keep in mind another thing I do not like about this knob.

The IETF draft has a requirement that we fallback to 3 seconds if the
initial RTO is 1 second.

Nothing in your facilities ensure this, or provide a way for the
kernel to make sure this is the case.

And for other values of initial RTO, what fallback is appropriate?

As a result of all of this, I do not really think this is something
the user should control at all.

I really would rather see the initial RTO be static and be set to 1
with fallback RTO of 3.
