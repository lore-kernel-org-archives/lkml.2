Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab2KJEg7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 23:36:59 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:35947 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885Ab2KJEgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 23:36:55 -0500
MIME-Version: 1.0
Date: Fri, 9 Nov 2012 20:36:53 -0800
Message-ID: <CANN689FmsFBjfiD8V-nQyDh+GtTF5B3SDUcuXc=3OeeN6JW0kw@mail.gmail.com>
Subject: Issues with "x86, um: switch to generic fork/vfork/clone" commit
From: Michel Lespinasse <walken@google.com>
To: Al Viro <viro@zeniv.linux.org.uk>, linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm having an issue booting current linux-next kernels on my test
machines. Userspace crashes when it's supposed to pivot to the rootfs.
With the loglevel=8 kernel parameter, the last messages I see are:

Checking root filesystem in pivot_root init.
[    6.252717] usb 2-1: link qh256-0001/ffff880853ec9ab8 start 1 [1/0 us]
[    6.259419] hub 2-1:1.0: state 7 ports 8 chg 0000 evt 0000
[    6.292302] traps: hotplug[1633] general protection ip:f767c06b
sp:ffbb2d1c error:0 in libc-2.3.6.so[f7652000+126000]

I ran a bisection and it turns out that
e52d03a3775841cc68d0ea9d86f2f09b603c41e6 (x86, um: switch to generic
fork/vfork/clone) is the commit breaking my setup. When reverting
that, I am able to boot linux-next (or mmotm, which is what I was
trying to do in the first place) without issues.

Sorry for not having a more complete root cause at the moment - I'm
lacking some context as to what the change is trying to do.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
