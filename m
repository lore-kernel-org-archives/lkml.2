Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284Ab1FVSV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 14:21:27 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36625 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757743Ab1FVSV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 14:21:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=HwxodB4BYhX9ismbYOA+tcbG5KPA9J9JfiJAGNOdp6K27IcTOrJ+dY9XKzKxN8c90J
         jR5P51SBmAIuXz2CU0AMPcDwnGPjgtZb6NBGfSih4a3yPK09+ZLjbdv53Fk3592o1lXw
         GjpCCYl6ufdta3xQ2x8GeHobBktUjaAELZkaU=
MIME-Version: 1.0
Date: Wed, 22 Jun 2011 11:21:25 -0700
Message-ID: <BANLkTik9J3qcdPcp+DdfRq9kj+DMKnjKZw@mail.gmail.com>
Subject: Issue with Race Condition on NFS4 with KRB
From: Joshua Scoggins <theoretically.x64@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

We are trying to update our linux images in our CS lab and have it a
bit of an issue. We are
using nfs to load user home folder. While testing the new image we
found that the nfs4 module will
 crash when using firefox 3.6.17 for an extended period of time. Some
research via google yielded that
it's a potential race condition specific to nfs with krb auth with
newer kernels. Our old image doesn't have
this issue and it seems that its due to it running a far older kernel version.

We have two images and both are having this problem. One is running
2.6.39 and the other is 2.6.38.
Here is what dmesg spit out from the machine running 2.6.39 on one occasion:

[  678.632061] ------------[ cut here ]------------
[  678.632068] WARNING: at net/sunrpc/clnt.c:1567 call_decode+0xb2/0x69c()
[  678.632070] Hardware name: OptiPlex 755
[  678.632072] Modules linked in: nvidia(P) scsi_wait_scan
[  678.632078] Pid: 3882, comm: kworker/0:2 Tainted: P
2.6.39-gentoo-r1 #1
[  678.632080] Call Trace:
[  678.632086]  [<ffffffff81035b20>] warn_slowpath_common+0x80/0x98
[  678.632091]  [<ffffffff8117231e>] ? nfs4_xdr_dec_readdir+0xba/0xba
[  678.632094]  [<ffffffff81035b4d>] warn_slowpath_null+0x15/0x17
[  678.632097]  [<ffffffff81426f48>] call_decode+0xb2/0x69c
[  678.632101]  [<ffffffff8142d2b5>] __rpc_execute+0x78/0x24b
[  678.632104]  [<ffffffff8142d4c9>] ? rpc_execute+0x41/0x41
[  678.632107]  [<ffffffff8142d4d9>] rpc_async_schedule+0x10/0x12
[  678.632111]  [<ffffffff8104a49d>] process_one_work+0x1d9/0x2e7
[  678.632114]  [<ffffffff8104c402>] worker_thread+0x133/0x24f
[  678.632118]  [<ffffffff8104c2cf>] ? manage_workers+0x18d/0x18d
[  678.632121]  [<ffffffff8104f6a0>] kthread+0x7d/0x85
[  678.632125]  [<ffffffff8145e314>] kernel_thread_helper+0x4/0x10
[  678.632128]  [<ffffffff8104f623>] ? kthread_worker_fn+0x13a/0x13a
[  678.632131]  [<ffffffff8145e310>] ? gs_change+0xb/0xb
[  678.632133] ---[ end trace 6bfae002a63e020e ]---

Is there some sort of work around?

Thank you in advance

Joshua Scoggins
