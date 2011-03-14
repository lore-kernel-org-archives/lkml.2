Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423Ab1CNWW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 18:22:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59973
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751529Ab1CNWW4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 18:22:56 -0400
Date: Mon, 14 Mar 2011 15:23:34 -0700 (PDT)
Message-Id: <20110314.152334.27803075.davem@davemloft.net>
To: remi.denis-courmont@nokia.com
Cc: jslaby@suse.cz, jirislaby@gmail.com, netdev@vger.kernel.org,
        gregkh@suse.de, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] NET: cdc-phonet, fix stop-queue handling
From: David Miller <davem@davemloft.net>
In-Reply-To: <201103140939.57056.remi.denis-courmont@nokia.com>
References: <1300035271-8138-1-git-send-email-jslaby@suse.cz>
	<201103140939.57056.remi.denis-courmont@nokia.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rémi Denis-Courmont" <remi.denis-courmont@nokia.com>
Date: Mon, 14 Mar 2011 09:39:56 +0200

> On Sunday 13 March 2011 18:54:30 ext Jiri Slaby, you wrote:
>> Currently there is a warning emitted by the cdc-phonet driver:
>> WARNING: at include/linux/netdevice.h:1557 usbpn_probe+0x3bb/0x3f0
>> [cdc_phonet]() Modules linked in: ...
>> Pid: 5877, comm: insmod Not tainted 2.6.37.3-16-desktop #1
>> Call Trace:
>>  [<ffffffff810059b9>] dump_trace+0x79/0x340
>>  [<ffffffff81520fdc>] dump_stack+0x69/0x6f
>>  [<ffffffff810580eb>] warn_slowpath_common+0x7b/0xc0
>>  [<ffffffffa00254fb>] usbpn_probe+0x3bb/0x3f0 [cdc_phonet]
>> ...
>> ---[ end trace f5d3e02908603ab4 ]---
>> netif_stop_queue() cannot be called before register_netdev()
>> 
>> So remove netif_stop_queue from the probe funtction to avoid that.
>> 
>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
>> Cc: Rémi Denis-Courmont <remi.denis-courmont@nokia.com>
>> Cc: David S. Miller <davem@davemloft.net>
> 
> Acked-by: Rémi Denis-Courmont <remi.denis-courmont@nokia.com>

Applied.
