Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab1EGII2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 04:08:28 -0400
Received: from lo.gmane.org ([80.91.229.12]:59443 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402Ab1EGIIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 04:08:23 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: How to disable TCP checksum calculation?
Date: Sat, 7 May 2011 08:28:30 +0100
Message-ID: <ut8f98-hoj.ln1@chipmunk.wormnet.eu>
References: <A24AE1FFE7AEC5489F83450EE98351BF35079BA24F@shsmsx502.ccr.corp.intel.com>
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: chipmunk.wormnet.eu
User-Agent: tin/1.9.6-20100522 ("Lochruan") (UNIX) (Linux/2.6.32-5-sparc64-smp (sparc64))
Cc: linux-wireless@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu, Xia <xia.wu@intel.com> wrote:
>
> I'm studying TCP transporting efficiency. Now I want to disable TCP 
> checksum calculation, but I cannot find the right way to disable it. 
> Who can give me a help on how to disable TCP checksum on Linux?
> 
Look at using TCP checksum offloading to see the effects:

http://en.wikipedia.org/wiki/TCP_Offload_Engine

----
berk:/home/alex# ethtool -k eth0
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
receive-hashing: on
----

Cheers

-- 
Alexander Clouter
.sigmonster says: Dental health is next to mental health.

