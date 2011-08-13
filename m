Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab1HMWRh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 18:17:37 -0400
Received: from acheron.ifi.lmu.de ([129.187.214.135]:44823 "EHLO
	acheron.ifi.lmu.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab1HMWRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 18:17:36 -0400
From: Michael Brade <brade@informatik.uni-muenchen.de>
Organization: =?utf-8?q?Ludwig-Maximilians-Universit=C3=A4t?= =?utf-8?q?_M=C3=BCnchen?=
To: linux-kernel@vger.kernel.org
Subject: [SOLVED: r8169 is the culprit] Re: 2.6.39, 3.0.0-rc7+: complete system freeze with rsync on big directory
Date: Sun, 14 Aug 2011 00:17:30 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.1+; KDE/4.6.5; x86_64; ; )
References: <201107211119.15496.brade@informatik.uni-muenchen.de> <20110721112804.7aa0043d.taeuber@bbaw.de> <201107212013.14561.brade@informatik.uni-muenchen.de>
In-Reply-To: <201107212013.14561.brade@informatik.uni-muenchen.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108140017.31063.brade@informatik.uni-muenchen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

finally I found the reason for my system freeze: the r8169 module. The freeze 
happens only on heavy network loads, i.e. > 70 MB/s. iSCSI is really fast, 
that's why I only saw the freezes with iSCSI.

> But watching the normal console I get loads of
> 
> r8169 0000:13:00.0: eth0: link up
> r8169 0000:13:00.0: eth0: link up

This does not happen with 2.6.32.28, and the system doesn't freeze either with 
this kernel. So the r8169 is fine on 2.6.32.x. 2.6.37 and above freeze the 
system. I haven't tried any kernel in between .32 and .37.

> [...]
> 
> lspci:
> 
> 13:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B
> PCI Express Gigabit Ethernet controller (rev 03)

The solution with 2.6.37 and above: use the r8168 module from the realtek 
website. I have tested it with >30 GB at rates of 112 MB/s and experienced no 
freeze anymore.

I don't know if you are interested in fixing r8169 but if so and you need 
anything, let me know how I can help.

cheers,
  Michael
