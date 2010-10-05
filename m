Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab0JESCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 14:02:09 -0400
Received: from mail.candelatech.com ([208.74.158.172]:53837 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab0JESCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 14:02:08 -0400
X-Greylist: delayed 1908 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Oct 2010 14:02:08 EDT
Message-ID: <4CAB60AB.5060808@candelatech.com>
Date: Tue, 05 Oct 2010 10:30:19 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Can SLUB debugging show back-trace for deletion point?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm debugging a wireless issue that is apparently a write-after-free
issue with skbs.

Oct  5 09:50:18 localhost kernel: =============================================================================
Oct  5 09:50:18 localhost kernel: BUG kmalloc-8192: Poison overwritten
Oct  5 09:50:18 localhost kernel: -----------------------------------------------------------------------------
Oct  5 09:50:18 localhost kernel:
Oct  5 09:50:18 localhost kernel: INFO: 0xf5b18040-0xf5b1812f. First byte 0x80 instead of 0x6b
Oct  5 09:50:18 localhost kernel: INFO: Allocated in ath_rxbuf_alloc+0x1d/0x74 [ath] age=54091 cpu=0 pid=613
Oct  5 09:50:18 localhost kernel: INFO: Freed in skb_release_data+0x8c/0x90 age=89 cpu=0 pid=4029
Oct  5 09:50:18 localhost kernel: INFO: Slab 0xc1fef300 objects=3 used=2 fp=0xf5b18000 flags=0x400040c1
Oct  5 09:50:18 localhost kernel: INFO: Object 0xf5b18000 @offset=0 fp=0x(null)
....

I get a backtrace for the point at which this is detected, but it seems what would
really be useful is a backtrace for where it was freed.

Is there any way to get that information printed out by slub debugging?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

