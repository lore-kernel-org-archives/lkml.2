Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab2LRM6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 07:58:12 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:38529 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab2LRM6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 07:58:11 -0500
X-Greylist: delayed 1067 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Dec 2012 07:58:11 EST
MIME-Version: 1.0
X-Originating-IP: [85.143.161.18]
From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Date: Tue, 18 Dec 2012 16:33:47 +0400
X-Google-Sender-Auth: vUH3kVLuMpHW4WEpfirS39xmfpc
Message-ID: <CACaajQtd_CF+EBaDGZXH3mdHVKUsii9YTJOXvKyT7WcfqvLq7g@mail.gmail.com>
Subject: failed to setups device_weight for bio device (/dev/mdxxx)
To: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does anobody can helps me?
Hello. I'm newbie with cgroups (try to use blkio cgroups).
I need to shape disk activity on xen vps.
Each xen domU have block device that is software raid 1.
This raid have two devices that is lvm volume lies on srp (infiniband)
attached disk.

How can i limit disk usage in this configuration with cgroups?

P.S. Some log:

:~ # ls -alo /dev/md116
brw-rw---- 1 root 9, 116 Dec 17 15:44 /dev/md116
:~ # /bin/echo 9:116 0 > /cgroups/blkio.weight_device
/bin/echo: write error: Invalid argument

/dev/md116 consist:
/dev/dm-30 and /dev/dm-31

:~ # /bin/echo 253:30 14 > /cgroups/blkio.weight_device
/bin/echo: write error: Invalid argument
:~ # /bin/echo 253:31 14 > /cgroups/blkio.weight_device
/bin/echo: write error: Invalid argument

--
Vasiliy Tolstov,
Clodo.ru
e-mail: v.tolstov@selfip.ru
jabber: vase@selfip.ru
