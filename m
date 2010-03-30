Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab0C3TSF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 15:18:05 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:6211 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab0C3TSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 15:18:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=ri9YEicueKiS+JDMhjIRgSjVRY905cj7gwhb6Rt5FBCAZsU+d2C5AF4+heMHgShVh7
         sD/sxsIQ4td9qBs8TjMBrQAiVTb/gA1vAcnZ13RQIscVgwZ/pnTiCuSM2ARZXvyfklci
         WpOs9ZQUoAbdW8TlUFzHQv2CW9r2uMUm8Mht8=
Message-ID: <4BB24E5F.3030703@lwfinger.net>
Date: Tue, 30 Mar 2010 14:17:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.34-rc3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remember our old friend? See also
http://lkml.indiana.edu/hypermail/linux/kernel/1003.1/02769.html and a long
related discussion at
http://lkml.indiana.edu/hypermail/linux/kernel/1003.1/02772.html.

BUG: key ffff8800374d2660 not in .data!
------------[ cut here ]------------
WARNING: at kernel/lockdep.c:2706 lockdep_init_map+0x236/0x5d0()
Hardware name: HP Pavilion dv2700 Notebook PC
Modules linked in: processor(+) ide_pci_generic amd74xx ide_core thermal
Pid: 612, comm: modprobe Not tainted 2.6.34-rc3-Linus #192
Call Trace:
 [<ffffffff81046168>] warn_slowpath_common+0x78/0xb0
 [<ffffffff810461af>] warn_slowpath_null+0xf/0x20
 [<ffffffff810772c6>] lockdep_init_map+0x236/0x5d0
 [<ffffffff811649aa>] sysfs_add_file_mode+0x6a/0xc0
 [<ffffffff811acaa0>] ? sprintf+0x40/0x50
 [<ffffffff81164a0c>] sysfs_add_file+0xc/0x10
 [<ffffffff81164ae1>] sysfs_create_file+0x21/0x30
 [<ffffffff81247cc4>] device_create_file+0x14/0x20
 [<ffffffff8126d7d4>] thermal_zone_bind_cooling_device+0x1c4/0x310
-- dump truncated here --

I understand that you do not want a whole set of such "fix one such bug at a
time" patches, but the bottom line is that these lockdep warnings for known
problems interfere with "normal" debugging because further lockdep checking is
disabled. I do not feel qualified to detect other cases and fix them. Only when
a warning hits my logs am I qualified to fix and test.

Larry

