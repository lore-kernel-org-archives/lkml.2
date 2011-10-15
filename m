Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129Ab1JOAjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 20:39:19 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64093 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609Ab1JOAjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 20:39:17 -0400
MIME-Version: 1.0
Date: Sat, 15 Oct 2011 08:39:16 +0800
Message-ID: <CAFeW=pZcqnybTeMQPEMUguAwwgqpM1Hap2Dh3K-5majfYqMTaA@mail.gmail.com>
Subject: cgroup: denying device doesn't work with 'rw' mode string
From: Amos Kong <kongjianjun@gmail.com>
To: serue@us.ibm.com, viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

# mount -t cgroup -o devices none /cgroup
# mkdir /cgroups/devices
# ls -l /dev/vg/lv
lrwxrwxrwx. 1 root root 7 Oct 14 19:03 /dev/vg/lv -> ../dm-3
# ls -l /dev/dm-3
brw-rw----. 1 root disk 253, 3 Oct 14 19:03 /dev/dm-3


------- test1
# echo a > devices/devices.allow
# echo 'b 253:3 rwm' > devices/devices.deny
                ^^^
# echo $$ > task
# dd if=/dev/zero of=/dev/dm-3 bs=1M count=1
couldn't write to /dev/dm-3 successfully

------- test2
deny read-write permission of dm-3, but it doesn't effect.

# echo a > devices/devices.allow
# echo 'b 253:2 rw' > devices.deny
                ^^
# echo $$ > task
# dd if=/dev/zero of=/dev/dm-3 bs=1M count=1
can write to /dev/dm-3 successfully ???

-----------

related upstream commit:
commit 08ce5f16ee466ffc5bf243800deeecd77d9eaf50
Author: Serge E. Hallyn <serue@us.ibm.com>
Date:   Tue Apr 29 01:00:10 2008 -0700

    cgroups: implement device whitelist


cgroup tracks and enforces open and mknod restrictions on device files,
so 'm' are always needed in the mode string? 'rw' is uneffective?
