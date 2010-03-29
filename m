Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab0C2QVG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 12:21:06 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:62360 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154Ab0C2QVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 12:21:04 -0400
Message-ID: <4BB0D2CF.9040903@nortel.com>
Date: Mon, 29 Mar 2010 10:18:23 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Brandon Black <blblack@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: behavior of recvmmsg() on blocking sockets
References: <84621a61003240915p2a4ce6bbjd0c6bfb02ab05ba8@mail.gmail.com>	 <4BAA4EE4.3090900@nortel.com>	 <84621a61003241128x3afbcea1w387aeaa68c887320@mail.gmail.com>	 <4BAA69BF.3080600@nortel.com>	 <84621a61003241255i74282f53v3bb0111808895401@mail.gmail.com> <84621a61003270619p6b4fe81bi24bb1961aba77ffb@mail.gmail.com>
In-Reply-To: <84621a61003270619p6b4fe81bi24bb1961aba77ffb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Mar 2010 16:20:39.0881 (UTC) FILETIME=[C5AB9390:01CACF5B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2010 07:19 AM, Brandon Black wrote:

> I've been playing with the timeout argument to recvmmsg as well now,
> and I'm struggling to see how one would ever use it correctly with the
> current implementation.

I'd probably do something like this:

prev = current time
loop forever
	cur = current time
	timeout = max_latency - (cur - prev)
	recvmmsg(timeout)
	process all received messages
	prev = cur


Basically you determine the max latency you're willing to wait for a
packet to be handled, then subtract the amount of time you spent
processing messages from that and pass it into the recvmmsg() call as
the timeout.  That way no messages will be delayed for longer than the
max latency. (Not considering scheduling delays.)

Chris
