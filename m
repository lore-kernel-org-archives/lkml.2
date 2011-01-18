Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab1ARTvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 14:51:11 -0500
Received: from webmail10.mail.sp.isp-net.nl ([217.149.192.62]:41436 "EHLO
	webmail10.mail.sp.isp-net.nl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752272Ab1ARTvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 14:51:10 -0500
Message-ID: <4D35EF64.1040906@xmsnet.nl>
Date: Tue, 18 Jan 2011 20:52:04 +0100
From: Hans de Bruin <jmdebruin@xmsnet.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101125 Thunderbird/3.0.11
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, jesse@nicira.com
Subject: [regression] 2.6.37+ commit 0363466866d9.... breaks tcp ipv6
References: <4D335417.80704@xmsnet.nl>
In-Reply-To: <4D335417.80704@xmsnet.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Language-Detected: en
X-Spam-Scanned: InterNLnet Mail Scan System V2.03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2011 09:24 PM, Hans de Bruin wrote:
> After last nights compile i lost the possibility to connect to ssh and
> http over ipv6. The connection stops at syn_sent. connections to my
> machine end in syn_recv. ping6 still works.
>

The bisect ended in:

0363466866d901fbc658f4e63dd61e7cc93dd0af is the first bad commit
commit 0363466866d901fbc658f4e63dd61e7cc93dd0af
Author: Jesse Gross <jesse@nicira.com>
Date:   Sun Jan 9 06:23:35 2011 +0000

     net offloading: Convert checksums to use centrally computed features.

     In order to compute the features for other offloads (primarily
     scatter/gather), we need to first check the ability of the NIC to
     offload the checksum for the packet.  Since we have already computed
     this, we can directly use the result instead of figuring it out
     again.

     Signed-off-by: Jesse Gross <jesse@nicira.com>
     Signed-off-by: David S. Miller <davem@davemloft.net>


ssh ::1  still works. And since dns still works I guess udp is not 
affected. My nic is a:

09:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5752 
Gigabit Ethernet PCI Express (rev 02)

-- 
Hans

