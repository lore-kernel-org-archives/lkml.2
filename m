Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab0DLOeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 10:34:36 -0400
Received: from mail2.ruggedcom.com ([204.50.148.11]:38201 "EHLO
	mail2.ruggedcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab0DLOef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 10:34:35 -0400
Message-ID: <4BC32F7A.4040809@ruggedcom.com>
Date: Mon, 12 Apr 2010 10:34:34 -0400
From: Michael Barkowski <michaelbarkowski@ruggedcom.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: "David S. Miller" <davem@davemloft.net>, Julia Lawall <julia@diku.dk>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: hdlc_ppp: why no detach()?
References: <4BC32B00.1030600@ruggedcom.com>
In-Reply-To: <4BC32B00.1030600@ruggedcom.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Apr 2010 14:34:37.0199 (UTC) FILETIME=[46FFD9F0:01CADA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Barkowski wrote:
> Hello Krzyztof,
> 
> I am looking at your hdlc_ppp code and I don't understand: why is there
> not the equivalent of fr_detach() in there?
> 
> pc8300_drv:cpc_remove_one() frees netdevs quite confidently but I wonder
> how it can be so sure that there are not skbs in hdlc_ppp's tx_queue
> associated with those devices before freeing them....
> 

the above is the real danger I see - free the netdev, then ppp's timer
comes along and dequeues from tx_queue an skb with invalid device.

> Even if you wanted to switch a device from PPP to Frame Relay, I don't
> see the method right now.  If I may ask, please, what am I missing?
> 

Ok - this part was a momentary lapse on my part - please strike from
the record :)

> If you agree there is a need for detach(), I would be happy to work on
> it and make a submission.
> 
> thanks for your time,
> 


-- 
Michael Barkowski
905-482-4577
