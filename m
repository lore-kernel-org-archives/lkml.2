Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab1GHF6l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:58:41 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:38379 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab1GHF6k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:58:40 -0400
MIME-Version: 1.0
Date: Fri, 8 Jul 2011 13:58:39 +0800
Message-ID: <CA+gQ4teG7wKXk+zkZvHYWRCqtoLE=qQOcns9zeth+Dt-xPixTg@mail.gmail.com>
Subject: PROBLEM: md/raid5 bug by commit 415e72d03
From: Qin Dehua <qindehua@gmail.com>
To: neilb@suse.de
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By bisecting, commit 415e72d03(md/raid5: Allow recovered part of
partially recovered devices to be in-sync) was found as the cause of
follow problem:
	* md1_raid5 or md1_raid6 process will hang(99% CPU usage) after
repeatedly remove disk from then re-add disk to raid5 or raid6£¨there
is also a dd process write to the raid continuously).
	
Hardware platform is IOP 341 XScale processor(did not test on other
platforms£©. The problem can be reproduced with this script:

{ while true; do dd if=/dev/zero of=/dev/md1 bs=1M count=90000 >
/dev/null 2>/dev/null;done; } &

while true;do
	mdadm /dev/md1 -f /dev/sda /dev/sdb
	sleep 1
	mdadm /dev/md1 -r /dev/sda /dev/sdb
	sleep 1
	mdadm /dev/md1 -a /dev/sda /dev/sdb
	sleep 6
done

Regards,
Qin Dehua
