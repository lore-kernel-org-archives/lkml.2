Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab0JGWJj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 18:09:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54387 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab0JGWJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 18:09:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=HwfAeDw768Et8RjpbTKO5sIwj/SdpyHUvRiDPCsMWNFe0YVAOhpyCsRUOkB4ZKuQik
         4EFDMiPLKJRhzTYF/RZCwjq9oDtNPAdF/nzNF8o1PROMFjHnh4Iea2a5p6nS+3TzIAPn
         FpZNgLGBL1qEWL6hjLibAOyWmySK4TcJJ4hVg=
Message-ID: <4CAE4479.6010606@gmail.com>
Date: Fri, 08 Oct 2010 00:06:49 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.9) Gecko/20100914 SUSE/3.1.4 Thunderbird/3.1.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        ML netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: IPv4: sysctl table check failed [was: mmotm 2010-10-07-14-08 uploaded]
References: <201010072140.o97Le69i025659@imap1.linux-foundation.org>
In-Reply-To: <201010072140.o97Le69i025659@imap1.linux-foundation.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2010 11:08 PM, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2010-10-07-14-08 has been uploaded to

Hi, I got bunch of "sysctl table check failed" below. All seem to be
related to ipv4:

sysctl table check failed: /net/ipv4/tcp_mem  No min
Pid: 1, comm: swapper Not tainted 2.6.36-rc7-mm1_64+ #1285
Call Trace:
 [<ffffffff8108d444>] set_fail+0xa4/0xf0
 [<ffffffff8108d736>] sysctl_check_table+0x2a6/0x310
 [<ffffffff8108d4eb>] sysctl_check_table+0x5b/0x310
 [<ffffffff8108d4eb>] sysctl_check_table+0x5b/0x310
 [<ffffffff81072204>] __register_sysctl_paths+0xf4/0x320
 [<ffffffff815c1232>] ? printk+0x3c/0x42
 [<ffffffff8115d3bc>] ? sysfs_add_file+0xc/0x10
 [<ffffffff818b18bd>] ? sysctl_ipv4_init+0x0/0x87
 [<ffffffff81072456>] register_sysctl_paths+0x26/0x30
 [<ffffffff818b18fd>] sysctl_ipv4_init+0x40/0x87
 [<ffffffff810002df>] do_one_initcall+0x3f/0x170
 [<ffffffff81884d44>] kernel_init+0x158/0x1e2
 [<ffffffff8102fb54>] kernel_thread_helper+0x4/0x10
 [<ffffffff81884bec>] ? kernel_init+0x0/0x1e2
 [<ffffffff8102fb50>] ? kernel_thread_helper+0x0/0x10
sysctl table check failed: /net/ipv4/tcp_mem  No max
Pid: 1, comm: swapper Not tainted 2.6.36-rc7-mm1_64+ #1285
Call Trace:
 [<ffffffff8108d444>] set_fail+0xa4/0xf0
 [<ffffffff8108d4da>] sysctl_check_table+0x4a/0x310
 [<ffffffff8108d4eb>] sysctl_check_table+0x5b/0x310
 [<ffffffff8108d4eb>] sysctl_check_table+0x5b/0x310
 [<ffffffff81072204>] __register_sysctl_paths+0xf4/0x320
 [<ffffffff815c1232>] ? printk+0x3c/0x42
 [<ffffffff8115d3bc>] ? sysfs_add_file+0xc/0x10
 [<ffffffff818b18bd>] ? sysctl_ipv4_init+0x0/0x87
 [<ffffffff81072456>] register_sysctl_paths+0x26/0x30
 [<ffffffff818b18fd>] sysctl_ipv4_init+0x40/0x87
 [<ffffffff810002df>] do_one_initcall+0x3f/0x170
 [<ffffffff81884d44>] kernel_init+0x158/0x1e2
 [<ffffffff8102fb54>] kernel_thread_helper+0x4/0x10
 [<ffffffff81884bec>] ? kernel_init+0x0/0x1e2
 [<ffffffff8102fb50>] ? kernel_thread_helper+0x0/0x10
sysctl table check failed: /net/ipv4/udp_mem  No min
Pid: 1, comm: swapper Not tainted 2.6.36-rc7-mm1_64+ #1285
Call Trace:
 [<ffffffff8108d444>] set_fail+0xa4/0xf0
 [<ffffffff8108d736>] sysctl_check_table+0x2a6/0x310
 [<ffffffff8108d4eb>] sysctl_check_table+0x5b/0x310
 [<ffffffff8108d4eb>] sysctl_check_table+0x5b/0x310
 [<ffffffff81072204>] __register_sysctl_paths+0xf4/0x320
 [<ffffffff815c1232>] ? printk+0x3c/0x42
 [<ffffffff8115d3bc>] ? sysfs_add_file+0xc/0x10
 [<ffffffff818b18bd>] ? sysctl_ipv4_init+0x0/0x87
 [<ffffffff81072456>] register_sysctl_paths+0x26/0x30
 [<ffffffff818b18fd>] sysctl_ipv4_init+0x40/0x87
 [<ffffffff810002df>] do_one_initcall+0x3f/0x170
 [<ffffffff81884d44>] kernel_init+0x158/0x1e2
 [<ffffffff8102fb54>] kernel_thread_helper+0x4/0x10
 [<ffffffff81884bec>] ? kernel_init+0x0/0x1e2
 [<ffffffff8102fb50>] ? kernel_thread_helper+0x0/0x10
sysctl table check failed: /net/ipv4/udp_mem  No max
Pid: 1, comm: swapper Not tainted 2.6.36-rc7-mm1_64+ #1285
Call Trace:
 [<ffffffff8108d444>] set_fail+0xa4/0xf0
 [<ffffffff8108d4da>] sysctl_check_table+0x4a/0x310
 [<ffffffff8108d4eb>] sysctl_check_table+0x5b/0x310
 [<ffffffff8108d4eb>] sysctl_check_table+0x5b/0x310
 [<ffffffff81072204>] __register_sysctl_paths+0xf4/0x320
 [<ffffffff815c1232>] ? printk+0x3c/0x42
 [<ffffffff8115d3bc>] ? sysfs_add_file+0xc/0x10
 [<ffffffff818b18bd>] ? sysctl_ipv4_init+0x0/0x87
 [<ffffffff81072456>] register_sysctl_paths+0x26/0x30
 [<ffffffff818b18fd>] sysctl_ipv4_init+0x40/0x87
 [<ffffffff810002df>] do_one_initcall+0x3f/0x170
 [<ffffffff81884d44>] kernel_init+0x158/0x1e2
 [<ffffffff8102fb54>] kernel_thread_helper+0x4/0x10
 [<ffffffff81884bec>] ? kernel_init+0x0/0x1e2
 [<ffffffff8102fb50>] ? kernel_thread_helper+0x0/0x10

regards,
-- 
js
