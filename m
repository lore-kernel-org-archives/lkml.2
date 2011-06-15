Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab1FOH6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 03:58:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136Ab1FOH6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 03:58:06 -0400
Message-ID: <4DF8660A.8020800@redhat.com>
Date: Wed, 15 Jun 2011 03:58:02 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Cong Wang <amwang@redhat.com>
CC: Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
        Neil Horman <nhorman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: netconsole regression w/ 8d8fc29d
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit 8d8fc29d02a33e4bd5f4fa47823c1fd386346093
(netpoll: disable netpoll when enslave a device), it is
no longer possible to use netconsole together with bridged
KVM guests.

I can see why the change looked reasonable from a networking
point of view, but this has completely disabled netconsole
functionality for a common KVM use case.

After the change, netconsole refuses to bind to eth0.

Since the bridge interface does not support polling,
netconsole cannot use that, either.

I am now reduced to taking digital photos of the last screen
of a kernel oops, instead of getting oopses streamed to my
logging server.

To me the "unpredictable results" were way preferable to
what we have now.

Is there a way forward to restore netconsole functionality
for people who use KVM with bridging, or is it best to just
revert this commit?

commit 8d8fc29d02a33e4bd5f4fa47823c1fd386346093
Author: Amerigo Wang <amwang@redhat.com>
Date:   Thu May 19 21:39:10 2011 +0000

     netpoll: disable netpoll when enslave a device

     V3: rename NETDEV_ENSLAVE to NETDEV_JOIN

     Currently we do nothing when we enslave a net device which is 
running netcon
     Neil pointed out that we may get weird results in such case, so 
let's disabl
     netpoll on the device being enslaved. I think it is too harsh to 
prevent
     the device being ensalved if it is running netconsole.

     By the way, this patch also removes the NETDEV_GOING_DOWN from 
netconsole
     netdev notifier, because netpoll will check if the device is 
running or not
     and we don't handle NETDEV_PRE_UP neither.

     This patch is based on net-next-2.6.

     Signed-off-by: WANG Cong <amwang@redhat.com>
     Cc: Neil Horman <nhorman@redhat.com>
     Signed-off-by: David S. Miller <davem@davemloft.net>


-- 
All rights reversed
