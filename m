Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab2AXR52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 12:57:28 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:40296 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244Ab2AXR51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 12:57:27 -0500
Message-ID: <4F1EF104.1040107@hp.com>
Date: Tue, 24 Jan 2012 09:57:24 -0800
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111109 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: leno soff <lnxuff@gmail.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, davem@davemloft.net
Subject: Re: How to accelerate tcp retransmition
References: <CAC=NXX3jdCAjmwTjQ-d43DWb-617a33nMcWb_UvBUyB_q7VZTQ@mail.gmail.com> <CAC=NXX2NLsChhuY5_Bv3HJ4fvnq7XpM7UksPS80uaZgGsJnfVw@mail.gmail.com>
In-Reply-To: <CAC=NXX2NLsChhuY5_Bv3HJ4fvnq7XpM7UksPS80uaZgGsJnfVw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2012 06:09 AM, leno soff wrote:
> On Tue, Jan 24, 2012 at 4:58 PM, leno soff<lnxuff@gmail.com>  wrote:
>> Hello everyone,
>>    I have a lot of client, say C1, C2, .. Cn, which route packets to
>> my servers through router R. But R will drop 70% - 90% _ non-SYN _
>> packets from clients to Server.

I think you should address that first - why does the router drop 70 to 
905 of the non-SYN segments it receives.  At first blush that sounds 
like a classic case of massive over-subscription, and any attempt to 
accelerate the retransmissions seems destined to trigger congestive 
collapse.

As a side issue, if the router is dropping 70 to 90% of the non-SYN 
segments, why is it not also dropping 70 to 90% of the SYN segments?

Also, I'm reasonably confident that an actual keepalive probe would not 
(or at least should not?) be considered in the three duplicate ACK 
heuristic.

rick jones
