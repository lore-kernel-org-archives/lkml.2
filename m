Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251Ab0HXWUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:20:35 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52767 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab0HXWUb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:20:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=ZGJQTPCyU65o80lr6yJSDmdwUt9Nx3c93CdF2M0ojVojoTwjj+pA3nEYQhFc2J6HZ6
         MYZJ3MmF0jjXtuXan477WPJXRxbkm0XBv/UZhVussIGHU0nytbjzr8htPf+PwsbQR3UA
         u6tLE9u8Lq6RdfoeFF9XadWdLS3/yOIJKqdXE=
MIME-Version: 1.0
Date: Wed, 25 Aug 2010 00:20:30 +0200
Message-ID: <AANLkTi=yQzDDHnX8HFrqCe8yqWuVA8b24zfPk5yZeWZk@mail.gmail.com>
Subject: Automount causes zero-pointer dereference in 2.6.36-rc2
From: "Christopher K." <c.krooss@googlemail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I'm using autofs to mount some cifs shares in my /home.
Running 2.6.36-rc2-git2, browsing /home results in the following error:

BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<c124a921>] strncmp+0x11/0x30
*pde = 00000000
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/virtual/bdi/cifs-5/uevent
Modules linked in:
Pid: 3496, comm: mount.cifs Not tainted 2.6.36-rc2-git2 #2 K50IJ
EIP: 0060:[<c124921>] EFLAGS: 00010216 CPU: 1
EIP is at strncmp+0x11/0x30
EAX: 00000000 EBX: f3a5d200 ECX: 000001ff EDX: 00000000
ESI: 00000000 EDI: 00000000 EBP: f3a98408 ESP: f3acde38
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process mount.cifs (pid: 3496, ti=f3acc000, task=f5adc800, task.ti=f3acc000)
Stack:
 f3a98400f5a24080 c119f122 00000000 00000000 00000000 00000000 00000000
<0> 00003674 00000000 00000000 f3a7f02e f5a24080 c17d4320 f5a837c0 c119f784
<0> c15c4280 f3acdea0 00000000 f3b2ae30 f3acdea4 f3b2ae00 00003673 f3b2ae30
Call Trace:
...cifs_get_smb_ses...
...cifs_mount...
...kmem_cache_alloc...
...cifs_get_sb...
...vfs_kern_mount...
...get_fs_type...
...do_kern_mount...
...do_mount...
...copy_mount_options...
...sys_mount...
...sysenter_do_call...

I believe it's kernel-related, as it does not occur in <= 2.6.35.2
Should I recompile my kernel to enable some more debugging-information?
Christopher
