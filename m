Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab0CWLcp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 07:32:45 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:42312 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464Ab0CWLcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 07:32:43 -0400
Message-ID: <4BA8A6DA.1000408@msgid.tls.msk.ru>
Date: Tue, 23 Mar 2010 14:32:42 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm@vger.kernel.org>
Subject: KSM & hugepages
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I noticed an interesting thing here, with qemu-kvm, KSM and
hugepages.

When I initially enabled KSM, for my two windows guests I've
seen ~100 000 pages in /sys/kernel/mm/ksm/pages_shared .
That's quite good, and overall memory usage improved.

Now, I also enabled hugepages in kvm, which speed things
up quite significantly (the speedup is noticeable).

But now, when both KSM and hugepages are activated, I don't
see KSM in action anymore.  /sys/../mm/pages_shared shows
56 pages, which is nothing.

So I wonder what's up:
 o that's 56 _huge_ pages (which means the actual saving
   is 56*2M = 112Mb, which isn't really bad).  If that's
   the case, /sys/../mm/ interface lacks proper units
   reporting;
 o due to large pages there's much less chance to find
   two pages with identical contents, so very little can
   be shared;
 o KSM does not scan hugepages at all
 o something else.

What is the issue here?

Thanks!

/mjt
