Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab0CZMC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 08:02:26 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:45383 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab0CZMCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 08:02:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=HmRl3LgXDI3JjaEt7CCWSuCj31T8LXm0EPh54wQrWL3GFld4kt2DXwi9/1g7EMvOK8
         OLKtXiY+sb+Ph6BlQRrgLy6FCy5D2DYYfz3VIiY4mIoeM/WwXx7F+pIP4KuZJCs1Px4w
         F7/Dr3skKsQbd0LYRC9cN3OyOxZ5en4SzF1TI=
MIME-Version: 1.0
Date: Fri, 26 Mar 2010 13:02:22 +0100
X-Google-Sender-Auth: a1b810942d33a230
Message-ID: <520f0cf11003260502o5ecb23adpe69f6eb465142821@mail.gmail.com>
Subject: [BUG-REPORT][PREEMPT-RT] 2.6.33.1-rt11 triggers DEBUG_LOCKS_WARN_ON(!p->hardirqs_enabled), 
	in a 32-bit kvm session
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During boot-up of 2.6.33.1-rt11 in a 32-bit qemu-kvm machine,
The following warning is reliably (every time) triggered.

------------[ cut here ]------------
WARNING: at /home/jkacur/jk-2.6/kernel/fork.c:1065 copy_process+0x299/0x160f()
Hardware name:
Modules linked in:
Pid: 64, comm: khelper Not tainted 2.6.33.1-rt11 #1
Call Trace:
 [<c104961a>] warn_slowpath_common+0x83/0x9a
 [<c1049643>] warn_slowpath_null+0x12/0x15
 [<c1046f89>] copy_process+0x299/0x160f
 [<c1048711>] do_fork+0x235/0x4e2
 [<c107da08>] ? register_lock_class+0x17/0x22d
 [<c107e6dc>] ? mark_lock+0x1e/0x1c0
 [<c1064a2f>] ? ____call_usermodehelper+0x0/0x138
 [<c100ae09>] kernel_thread+0x79/0x81
 [<c1064a2f>] ? ____call_usermodehelper+0x0/0x138
 [<c100391c>] ? kernel_thread_helper+0x0/0x10
 [<c1064cc7>] __call_usermodehelper+0x75/0xa0
 [<c10673b6>] worker_thread+0x1f6/0x2fb
 [<c1067374>] ? worker_thread+0x1b4/0x2fb
 [<c1064c52>] ? __call_usermodehelper+0x0/0xa0
 [<c106a91e>] ? autoremove_wake_function+0x0/0x46
 [<c106a740>] kthread+0x6b/0x74
 [<c10671c0>] ? worker_thread+0x0/0x2fb
 [<c106a6d5>] ? kthread+0x0/0x74
 [<c106a6d5>] ? kthread+0x0/0x74
 [<c1003922>] kernel_thread_helper+0x6/0x10
---[ end trace a22d306b065d4a66 ]---

I am happy to provide more information to help debug this.

Thanks
