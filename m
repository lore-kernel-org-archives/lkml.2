Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936832Ab0COVOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 17:14:49 -0400
Received: from karif.server-speed.net ([188.40.51.140]:39798 "EHLO
	karif.server-speed.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936780Ab0COVOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 17:14:47 -0400
X-Greylist: delayed 479 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Mar 2010 17:14:47 EDT
Message-ID: <4B9EA162.2000706@server-speed.net>
Date: Mon, 15 Mar 2010 22:06:42 +0100
From: Florian Pritz <bluewind@server-speed.net>
Organization: Server-Speed Network
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Shredder/3.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: sxxe@gmx.de, thomas@archlinux.org
Subject: Bad performance after suspend on Intel i7 and i5
X-Enigmail-Version: 1.0
OpenPGP: id=4CE1C13E;
	url=http://bluewind.at/stuff/other/0x4ce1c13e-pub.asc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When I run make -j12 (on a kernel tree) all 8 cores are at 100% each.
(Can also be tested with stress -c 8 or any multithreaded program)
After a suspend2ram (using pm-suspend) only one single core is at 100%
and the others are somewhere between 0% and 10% though not 100% like
before.

This bug is reproduceable on at least 3 machines, running on i7-920,
i7-860 and i5-520M.
Tested kernels are 2.6.33-ARCH (config [1]) , 2.6.32.9-ARCH and
2.6.34-rc1-00005-g522dba7 (only be me; config [2]).

/proc/cpuinfo shows 8 cpus before and after suspend.

My own hardware:
CPU: Intel i7-920
Board: Gigabyte GA-EX58-UD4P [3]
RAM: 8GB
Arch: x86_64 (all 3)
Distribution: Archlinux (all 3)

I don't know of any older good kernel, so sadly can't bisect anything.

Thanks for looking into that issue.

[1]
http://repos.archlinux.org/wsvn/packages/kernel26/trunk/config.x86_64?rev=70484&peg=70484
[2] http://flo.xssn.at/~flo/tmp/kernel-config
[3]
http://www.gigabyte.com.tw/Products/Motherboard/Products_Overview.aspx?ProductID=2986

-- 
Greetings,
Florian Pritz -- {flo,bluewind}@server-speed.net
