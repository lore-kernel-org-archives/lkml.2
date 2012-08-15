Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab2HOKWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 06:22:47 -0400
Received: from hera.cwi.nl ([192.16.191.8]:42253 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549Ab2HOKWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 06:22:46 -0400
X-Greylist: delayed 1800 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Aug 2012 06:22:45 EDT
Message-ID: <502B714E.4010700@cwi.nl>
Date: Wed, 15 Aug 2012 11:52:14 +0200
From: "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [perf] make clean problematic bashism
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear perf maintainers,

I attempted to compile perf 3.5.1 without worrying about installing 
dependencies first. The resulting error messages were quite helpful, and 
led me to install a bunch of development libraries and flex.

Unfortunately, after installing flex the build still failed, even after 
make clean.

The reason for this was a bunch of generated empty flex files in util/ 
that were not removed by make clean. They are intended to be erased, 
since the Makefile executes

rm -f util/*-{bison,flex}*

however, this command does not remove the files. I guess because {,} 
alternatives are only special in bash but the makefile is run with some 
other shell?

I got perf to compile now, but thought you would be interested to know 
about this little problem.

With kind regards,

Wouter Koolen


PS: as a side note: GNU make has the .DELETE_ON_ERROR: special target, 
which removes the target file when its generating command fails. This 
would have prevented my problem and sounds like a good idea in general. 
Maybe perf could make use of this feature when on GNU make?

