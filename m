Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab1LDOtT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 09:49:19 -0500
Received: from a82-161-213-135.adsl.xs4all.nl ([82.161.213.135]:43845 "HELO
	stokkie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754045Ab1LDOtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 09:49:17 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Dec 2011 09:49:16 EST
Date: Sun, 4 Dec 2011 15:42:34 +0100 (CET)
From: "Robert M. Stockmann" <stock@stokkie.net>
To: linux-kernel@vger.kernel.org
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Alan Cox <alan@linux.intel.com>
Subject: restrictions inside GCC 4.6.x and libc6-2.13 (x86_64)
Message-ID: <Pine.LNX.4.44.1112041459310.4682-100000@hubble.stokkie.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiVirus: scanned for viruses by AMaViS 0.2.4 ClamAV 0.97.3/14070/Sun Dec  4 03:53:11 2011 (http://crashrecovery.org/amavis.html)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

As i wanted to port some old source code [1] to the latest
ubuntu 11.10 x86_64 distribution i ran across a strange
observation :

[acer30:root]:(/usr/lib/x86_64-linux-gnu)# spfqtool -i 192.168.2.5 -s stock@stokkie.net -h stokkie.net
*** buffer overflow detected ***: spfqtool terminated
======= Backtrace: =========
/lib/x86_64-linux-gnu/libc.so.6(__fortify_fail+0x37)[0x7fb98f9537f7]
/lib/x86_64-linux-gnu/libc.so.6(+0xf7710)[0x7fb98f952710]
/lib/x86_64-linux-gnu/libc.so.6(+0xf6dfb)[0x7fb98f951dfb]
/lib/x86_64-linux-gnu/libc.so.6(__snprintf_chk+0x78)[0x7fb98f951cd8]
/usr/lib/libspf-1.0.so.0(SPF_init+0x277)[0x7fb98fbfc8e7]
spfqtool[0x400afb]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xed)[0x7fb98f87c30d]
spfqtool[0x400e1d]

[ ... ]"

This is also observed on ubuntu 11.04 x86_64 ..
When searching on google for this with 'spfqtool' omitted  :

*** buffer overflow detected ***:  terminated
http://www.google.com/search?hl=en&safe=off&q=***+buffer+overflow+detected+***%3A++terminated&oq=***+buffer+overflow+detected+***%3A++terminated&aq=f&aqi=g-v1g-b9&aql=&gs_sm=e&gs_upl=5641l6824l0l8707l9l9l0l0l0l0l111l878l4.5l9l0

i get about About 820,000 results (0.08 seconds), which reach from the 
year 2009 upto 2011.  I really wonder what is the trouble here, as such 
old source, which has run many CPU cycles for the last 8 years, now 
suddenly has become buggy and prone to buffer overflows ...

Any suggestions on how to migrate 'old code' to the new Linux
platforms ?

Best Regards,

Robert
[1] libspf (www.libspf.org)
    http://crashrecovery.org/SPF/RPMS/spf/src/
    http://crashrecovery.org/SPF/RPMS/spf/src/libspf-1.0.0-RC6-pre10.tar.bz2
-- 
Robert M. Stockmann - RHCE
Network Engineer - UNIX/Linux Specialist
crashrecovery.org  stock@stokkie.net

