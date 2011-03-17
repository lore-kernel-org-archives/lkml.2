Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab1CQC42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 22:56:28 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40658 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab1CQC40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 22:56:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=C5YV4zYViR3X165LDNvhCh0Lt4IIVrkzDN5z/BJ6qr1+O5nSmhS2wUDS8KgS0WhOMh
         32kv5QLUIi3fbpnlbLzl1HzhaJTDEqerDeeGpGX3Eob7sS3LiAinExviDW9oT7Z7KdZI
         I8g2WzzukzYQN1g+AElOEliPI+IdKlXLP8sO0=
MIME-Version: 1.0
Date: Wed, 16 Mar 2011 22:56:25 -0400
Message-ID: <AANLkTi=HB7s-VpMAZmNBPgvQadtN9tg91pFY-=atAWsM@mail.gmail.com>
Subject: what is the better method to do tsc synchronized check?
From: Luming Yu <luming.yu@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

I tested two different methods to do TSC sync check on a Sandy Bridge system.
The first TSC sync check method is from upstream -38-rc that considers
TSC is synced.
The second TSC sync check method is from a 2.6.18 based  kernel that
considers TSC
is NOT synced on the Sandy Bridge system. (I modified sync_tsc() to
just test (not modify TSC) on
the cpu being tested.)

[root@intel-sugarbay-DO-01 kernel]# dmesg | grep -i synchroniz
CPU 1: synchronized TSC with CPU 0 (last diff 29 cycles, maxerr 276 cycles)
CPU 2: synchronized TSC with CPU 0 (last diff 32 cycles, maxerr 280 cycles)
CPU 3: synchronized TSC with CPU 0 (last diff 31 cycles, maxerr 284 cycles)

Do you guy think we need to take 2.6.18-based tsc sync testing method
rather than the current one in upstream?

Any inputs are appreciated.


Thanks
Luming
