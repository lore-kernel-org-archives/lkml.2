Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759327Ab0HEWXa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:23:30 -0400
Received: from blade.4t2.com ([88.198.19.40]:38948 "EHLO blade.4t2.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756338Ab0HEWX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:23:27 -0400
X-Greylist: delayed 590 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Aug 2010 18:23:26 EDT
Subject: strange pagecache behaviour with dm-crypt on raid1
From: Tom Weber <l_linux-kernel@mail2news.4t2.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Aug 2010 00:13:20 +0200
Message-ID: <1281046400.22005.177.camel@morgoth.abyss.4t2.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-4t2Systems-MailScanner-Information: processed at blade.4t2.com
X-4t2Systems-MailScanner-ID: B97D8301F2.B555F
X-4t2Systems-MailScanner: Found to be clean
X-4t2Systems-MailScanner-From: l_linux-kernel@mail2news.4t2.com
X-4t2Systems-MailScanner-Watermark: 1281910411.61581@Lm2jMoIyHpQskpIxt0fbIw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I stumbled upon this while setting up a new System with

dm-crypt (/dev/mapper/md3dec) on top of 
/dev/md3 as raid1 (/dev/sd[ab]5)

and initially filling /dev/mapper/md3dec with zeros
dd if=/dev/zero of=/dev/mapper/md3dec bs=100M

i was curious about how far dd had progressed, so i played around with

dd if=/dev/md3 bs=1M count=1 skip=xx  | hexdump

to see if there were still zeros or already crypted data.

now say i found crypted data at offset xx=390000 and zeros at xx=400000
this dd command would always return zeros at 400000 even if the
originial filling dd progressed beyond 400000 (dd at 410000 would give
my crypted data).

up until freeing the page cache with
echo 1 > /proc/sys/vm/drop_caches
a dd at 400000 would always give me zeros (the first result).

is this intended behaviour or is there something going wrong?

this is 2.6.35-vs2.3.0.36.31 (vanilla + vserver patch) on x86_64.

  Tom




