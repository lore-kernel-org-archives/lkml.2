Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab1EaELG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 00:11:06 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37109 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab1EaELE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 00:11:04 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DE46A4B.40401@jp.fujitsu.com>
Date: Tue, 31 May 2011 13:10:51 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: caiqian@redhat.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, rientjes@google.com, hughd@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, oleg@redhat.com
Subject: Re: [PATCH v2 0/5] Fix oom killer doesn't work at all if system have
 > gigabytes memory  (aka CAI founded issue)
References: <2135926037.315785.1306805582148.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <2135926037.315785.1306805582148.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/31 10:33), CAI Qian wrote:
> Hello,
> 
> Have tested those patches rebased from KOSAKI for the latest mainline.
> It still killed random processes and recevied a panic at the end by
> using root user. The full oom output can be found here.
> http://people.redhat.com/qcai/oom

You ran fork-bomb as root. Therefore unprivileged process was killed at first.
It's no random. It's intentional and desirable. I mean

- If you run the same progream as non-root, python will be killed at first.
  Because it consume a lot of memory than daemons.
- If you run the same program as root, non root process and privilege explicit
  dropping processes (e.g. irqbalance) will be killed at first.


Look, your log says, highest oom score process was killed first.

Out of memory: Kill process 5462 (abrtd) points:393 total-vm:262300kB, anon-rss:1024kB, file-rss:0kB
Out of memory: Kill process 5277 (hald) points:303 total-vm:25444kB, anon-rss:1116kB, file-rss:0kB
Out of memory: Kill process 5720 (sshd) points:258 total-vm:97684kB, anon-rss:824kB, file-rss:0kB
Out of memory: Kill process 5457 (pickup) points:236 total-vm:78672kB, anon-rss:768kB, file-rss:0kB
Out of memory: Kill process 5451 (master) points:235 total-vm:78592kB, anon-rss:796kB, file-rss:0kB
Out of memory: Kill process 5458 (qmgr) points:233 total-vm:78740kB, anon-rss:764kB, file-rss:0kB
Out of memory: Kill process 5353 (sshd) points:189 total-vm:63992kB, anon-rss:620kB, file-rss:0kB
Out of memory: Kill process 1626 (dhclient) points:129 total-vm:9148kB, anon-rss:484kB, file-rss:0kB


