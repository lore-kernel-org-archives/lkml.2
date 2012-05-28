Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab2E1Dr7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:47:59 -0400
Received: from senator.holtmann.net ([87.106.208.187]:42576 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab2E1Drz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:47:55 -0400
Message-ID: <1338176868.15105.113.camel@aeonflux>
Subject: Re: [PATCH v2] Bluetooth: Really fix registering hci with duplicate
 name
From: Marcel Holtmann <marcel@holtmann.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: gustavo@padovan.org, johan.hedberg@gmail.com, davem@davemloft.net,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 28 May 2012 05:47:48 +0200
In-Reply-To: <1338151016-13494-1-git-send-email-levinsasha928@gmail.com>
References: <1338151016-13494-1-git-send-email-levinsasha928@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sasha,

> Commit fc50744 ("Bluetooth: Fix registering hci with duplicate name") didn't
> fully fix the duplicate naming issue with devices, and duplicate device names
> could still be created:
> 
> [  142.484097] device: 'hci1': device_add
> [...]
> [  150.545263] device: 'hci1': device_add
> [  150.550128] kobject: 'hci1' (ffff880014cc4e58): kobject_add_internal: parent: 'bluetooth', set: 'devices'
> [  150.558979] ------------[ cut here ]------------
> [  150.561438] WARNING: at fs/sysfs/dir.c:529 sysfs_add_one+0xb0/0xd0()
> [  150.572974] Hardware name: Bochs
> [  150.580502] sysfs: cannot create duplicate filename '/devices/virtual/bluetooth/hci1'
> [  150.584444] Pid: 7563, comm: trinity-child1 Tainted: G        W    3.4.0-next-20120524-sasha #296
> [...]
> 
> Instead of the weird logic and the attempt at keeping the device list sorted,
> just use an IDA.
> 
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> ---
> 
> Changes from v1:
> 
>  - Address comments by Marcel.
>  - Remove errornous mutex lock.
> 
>  net/bluetooth/hci_core.c |   41 ++++++++++++++++++++++++-----------------
>  1 files changed, 24 insertions(+), 17 deletions(-)

thanks for addressing this. Patch has been applied to bluetooth-next
tree.

Regards

Marcel


