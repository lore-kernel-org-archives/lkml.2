Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab1ARUGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 15:06:55 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:47979 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab1ARUGy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 15:06:54 -0500
MIME-Version: 1.0
In-Reply-To: <4D35EF64.1040906@xmsnet.nl>
References: <4D335417.80704@xmsnet.nl>
	<4D35EF64.1040906@xmsnet.nl>
Date: Tue, 18 Jan 2011 12:06:53 -0800
Message-ID: <AANLkTinejKw0pY5HncB2e0ocjqYuCwTBUwd2xkroWu+E@mail.gmail.com>
Subject: Re: [regression] 2.6.37+ commit 0363466866d9.... breaks tcp ipv6
From: Jesse Gross <jesse@nicira.com>
To: Hans de Bruin <jmdebruin@xmsnet.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 11:52 AM, Hans de Bruin <jmdebruin@xmsnet.nl> wrote:
> On 01/16/2011 09:24 PM, Hans de Bruin wrote:
>>
>> After last nights compile i lost the possibility to connect to ssh and
>> http over ipv6. The connection stops at syn_sent. connections to my
>> machine end in syn_recv. ping6 still works.
>>
>
> The bisect ended in:
>
> 0363466866d901fbc658f4e63dd61e7cc93dd0af is the first bad commit
> commit 0363466866d901fbc658f4e63dd61e7cc93dd0af
> Author: Jesse Gross <jesse@nicira.com>
> Date:   Sun Jan 9 06:23:35 2011 +0000
>
>    net offloading: Convert checksums to use centrally computed features.
>
>    In order to compute the features for other offloads (primarily
>    scatter/gather), we need to first check the ability of the NIC to
>    offload the checksum for the packet.  Since we have already computed
>    this, we can directly use the result instead of figuring it out
>    again.
>
>    Signed-off-by: Jesse Gross <jesse@nicira.com>
>    Signed-off-by: David S. Miller <davem@davemloft.net>
>
>
> ssh ::1  still works. And since dns still works I guess udp is not affected.
> My nic is a:
>
> 09:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5752 Gigabit
> Ethernet PCI Express (rev 02)

Are you using vlans?  If so, can you please test this patch?
http://patchwork.ozlabs.org/patch/79264/
