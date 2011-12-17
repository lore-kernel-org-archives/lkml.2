Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763Ab1LQXnK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 18:43:10 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:52045 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab1LQXnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 18:43:08 -0500
Message-ID: <1324165382.3323.59.camel@edumazet-laptop>
Subject: Re: Question about TCP Checksum errors
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sun, 18 Dec 2011 00:43:02 +0100
In-Reply-To: <4EED232D.3010208@lwfinger.net>
References: <4EED232D.3010208@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 17 décembre 2011 à 17:18 -0600, Larry Finger a écrit :
> In https://bugzilla.novell.com/show_bug.cgi?id=718736, a user reports that his 
> network using an RTL8188CE becomes very slow under "heavy" load. This condition 
> started when he updated from openSUSE 11.4 to 12.1. The kernels involved are 
> 2.6.37 and 3.1. I am unable to duplicate the problem.
> 
> Packet capture with Wireshark shows that the slow down is due to retransmissions 
> due to TCP checksum errors. I found nothing to explain the situation with a 
> Google search, thus I am asking here.
> 
> I put heavy in quotes because the traffic is from a web browser to yahoo.com, 
> thus the potential throughput is not very high.
> 
> As far as I know, this checksum is generated in a higher layer of the network 
> stack, and that data is just passed through the 802.11 layer, and the wireless 
> driver. Is this correct? Anyone have any ideas on where to look for the problem?
> 

I see nothing special in the packet capture from this bug report.

(Only suboptimal application opening many concurrent flows in //)

Keep in mind most modern NICS compute checksums themselve.

Linux offloads this to NIC

This can be controled eventually by "ethtool -k ethX" (-K to change
settings)

# ethtool -k eth0
Offload parameters for eth0:
rx-checksumming: on
tx-checksumming: on
scatter-gather: on
tcp-segmentation-offload: on
udp-fragmentation-offload: off
generic-segmentation-offload: on
generic-receive-offload: on
large-receive-offload: off
rx-vlan-offload: on
tx-vlan-offload: on
ntuple-filters: off
receive-hashing: off

# ethtool -K eth0 tx off
# ethtool -k eth0
Offload parameters for eth0:
rx-checksumming: on
tx-checksumming: off
scatter-gather: off
tcp-segmentation-offload: off
udp-fragmentation-offload: off
generic-segmentation-offload: off
generic-receive-offload: on
large-receive-offload: off
rx-vlan-offload: on
tx-vlan-offload: on
ntuple-filters: off
receive-hashing: off


