Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab2KRLF2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 06:05:28 -0500
Received: from [93.179.225.50] ([93.179.225.50]:49888 "EHLO shrek.podlesie.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751596Ab2KRLF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 06:05:26 -0500
Date: Sun, 18 Nov 2012 12:05:23 +0100
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: gregkh@linuxfoundation.org, moinejf@free.fr
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com
Subject: vt: regression caused by "Fix line garbage in virtual.."
Message-ID: <20121118110523.GA12094@shrek.podlesie.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

commit 81732c3b2fede049a692e58a7ceabb6d18ffb18c
(tty vt: Fix line garbage in virtual console on command line edition)
introduced some regression in deleting characters/clearing line during
selecting previous command in bash by using "up" arrow.


The problem can be reproduced by two following commands:

echo -n "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
echo -e "\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08\x08\x1b\x5b\x33\x50\x64\x72\x69\x76\x65\x72\x73\x2f\x69\x6e\x70\x75\x74\x2f\x6d\x6f\x75\x73\x65\x64\x65\x76\x2e\x63"

(the first command generates just some garbage, the second command
generates string captured by strace when the issue occured).


On Linux v3.6 the resulting line is:

...AAAdrivers/input/mousedev.c

with fbcon on inteldrmfb and v3.7-rc6
...AAAdrivers/input/mousedev.c  A

with fbcon on radeondrmfb and v3.7-rc6
...AAAdrivers/input/mousedev.cAAA


There are some garbage after mousedev.c not present on older kernels.

Reverting commit 81732c in v3.7-rc6 fixes the issue.

Krzysiek
