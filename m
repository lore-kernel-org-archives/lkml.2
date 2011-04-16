Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab1DPIGr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 04:06:47 -0400
Received: from smtpbg83.qq.com ([119.147.10.242]:41307 "HELO smtpbg83.qq.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751605Ab1DPIGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 04:06:43 -0400
X-Greylist: delayed 3403 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Apr 2011 04:06:41 EDT
X-QQ-mid: Yesmtp9t1302937684t433t17779
X-QQ-SSF: 0000000000000030FF6200000000000
Message-ID: <4DA94054.3030303@skybility.com>
Date: Sat, 16 Apr 2011 15:08:04 +0800
From: Lyre <liyong@skybility.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; zh-CN; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: alloc memory for massive legacy ptys
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all:

In a rare condition, I need to alloc massive legacy ptys on SLES 9 SP4,
kernel 2.6.5-7.308-smp.

I noticed the limit number of legacy ptys was 10922, due to the kmalloc
128kb limit. 10922 * 3 * sizeof (void *) was 8 bytes lesser than 128kb
on 32bit system.

I tried to use vmalloc instead of kmalloc in tty_register_driver(). My
system was able to boot, but I'm not sure if it was safely to do this,
since vmalloc don't guarant the phy memory were contiguous, and I don't
know the pty driver memory requirements neither.
