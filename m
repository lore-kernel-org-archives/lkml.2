Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382Ab1EFNdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 09:33:25 -0400
Received: from mailout.rz.uni-frankfurt.de ([141.2.22.233]:36982 "EHLO
	mailout.rz.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756259Ab1EFNdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 09:33:24 -0400
Message-ID: <4DC40484.3050205@gmx.de>
Date: Fri, 06 May 2011 16:24:04 +0200
From: Thomas Sattler <tsattler@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 Mnenhy/0.8.3 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: iotop: khugepaged at 99.99% (2.6.38.X)
References: <4DAF6C0B.3070009@gmx.de> <20110427134613.GI32590@random.random> <4DC14474.9040001@gmx.de> <20110504143842.GK7838@random.random> <4DC31EDE.2020503@gmx.de> <20110506011319.GH7838@random.random> <4DC3B629.7010409@gmx.de> <4DC3B72A.302@gmx.de>
In-Reply-To: <4DC3B72A.302@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Aaarg, wrong kernel tree. I patched and compiled 2.6.38.5.
> Do you think it is important to stay with 2.6.38.2, after
> we know 2.6.38.4 is also affected?

I bootet 2.6.38.5.aa1 ("aa1" for the "make-it-worse-patch")
but nothing happened within an hour. So I put some stress
on the system:

$ stress --cpu 80 --io 40 --vm 20 --vm-bytes 1280M --timeout 5s
stress: info: [31924] dispatching hogs: 80 cpu, 40 io, 20 vm, 0 hdd

The command _did_not_end_ after five seconds. I tried to
kill it after ~15 minutes. I had no success killing it.

"nr_isolated_anon" was "0" all the time. 'ps xal' hung its
terminal. Just like 'pkill stress', 'pkill firefox', 'pkill
thunderbird', 'pkill pkill' and 'pkill -9 stress'.

top/iotop: http://pastebin.com/raw.php?i=BCtmHpmX
ps xal:    http://pastebin.com/raw.php?i=ED71cuKe
zoneinfo:  http://pastebin.com/raw.php?i=aBNjz1Up

I hit SysRq-[lmtw] several times, you'll find all kernel
messages (/var/log/messages) from boot to reboot here:

  http://pastebin.com/raw.php?i=VG28YRbi

The system did not shutdown properly, I waited some time
for sshd to stop and eventually hit SysRq-sub.

Thomas
