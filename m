Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305Ab1AVGhh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 01:37:37 -0500
Received: from web63902.mail.re1.yahoo.com ([69.147.97.117]:43052 "HELO
	web63902.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751139Ab1AVGhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 01:37:36 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Jan 2011 01:37:36 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type;
  b=2Ci5PT1xbjWbroFDYAtLblRXYLPLtt46Mti3kpeAabCnJcOYW+x3Z4rdapLXkbuE1TwfSDCs2ReP8uEF+Ku+UtzlDrSMRllRxiestkkz8hnTqOeOAk4pLrCh3Zh2yARbcQ9gujohT9RNqmbtVSqpl34Y1VeVeXREzfqxUNR/ybs=;
Message-ID: <702550.61465.qm@web63902.mail.re1.yahoo.com>
X-YMail-OSG: W7Vv7LQVM1kTQ2jXspJ2ssTgI69eo.RchdcSXKUE_fWurF9
 _dl3HnwRiTK6XU6PdVVM.R8NZvaLPu8QLrnUCIWgp56FZ.WXK8vpjtLPBX5e
 RkK1XlDl1j7UwjSubIog.2bexKI7YwoeK__41NDtuCsMtUy.T.8gm1etHCyw
 U9a.jWLDkZvFuJSb9LucZfOpgPAQv0IBnO9M4.LjfGiYFeb4EshfeTLjUk7X
 qSp7_dlkhb.c4Iz1I4Pb92xyMoSRd7.E1OpaTdactXAubtPHfuHGXAmJUgs4
 w83L4SrFQtNPCmOMRhyOGD_g2yh_909pXepXgjN4eC5HJaNrw7yU-
X-Mailer: YahooMailRC/555 YahooMailWebService/0.8.107.285259
Date: Fri, 21 Jan 2011 22:30:54 -0800 (PST)
From: PK <runningdoglackey@yahoo.com>
Subject: Problems with /proc/net/tcp6  - possible bug - ipv6
To: linux-kernel@vger.kernel.org
Cc: runningdoglackey@yahoo.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Creating many ipv6 connections hits a ceiling on connections/fds ; okay, fine.

But in my case I'm seeing millions of entries spring up within a few seconds and 
then vanish within a few minutes, in /proc/net/tcp6 (vanish due to garbage 
collection?)

Furthermore I can trigger this easily on vanilla kernels from 2.6.36 to 
2.6.38-rc1-next-20110121  inside a ubuntu 10.10 amd64 vm, causing the kernel to 
spew warnings.  There is also some corruption in the logs (see kernel-sample.log 
line 296), but that may be unrelated.

More explanation, kernel config of the primary machine I saw this on, sample 
ruby script to reproduce (inside the ubuntu VMs I apt-get and use ruby-1.9.1), 
are located at
https://github.com/runningdogx/net6-bug

Seems to only affect 64-bit.  So far I have not been able to reproduce on 32-bit 
ubuntu VMs of any kernel version.
Seems to only affect IPv6.  So far I have not been able to reproduce using IPv4 
connections (and watching /proc/net/tcp of course).
Does not trigger the bug if the connections are made to ::1.  Only externally 
routable local and global IPv6 addresses seem to cause problems.
Seems to have been introduced between 2.6.35 and 2.6.36 (see README on github 
for more kernels I've tried)

All the tested Ubuntu VMs are stock 10.10 userland, with vanilla kernels (the 
latest ubuntu kernel is 2.6.35-something, and my initial test didn't show it 
suffering from this problem)

Originally noticed on separate Gentoo 64-bit non-vm system when doing web 
benchmarking.

not subscribed, so please keep me in cc although I'll try to follow the thread


      
