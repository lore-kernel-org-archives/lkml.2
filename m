Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab1H1QuB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 12:50:01 -0400
Received: from ixia-3.edge2.lax012.pnap.net ([74.217.148.5]:56134 "EHLO
	ixqw-mail-out.ixiacom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751907Ab1H1Qts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 12:49:48 -0400
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Aug 2011 12:49:48 EDT
Message-ID: <4E5A7094.90202@ixiacom.com>
Date: Sun, 28 Aug 2011 09:45:08 -0700
From: Earl Chew <echew@ixiacom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
Subject: %e in /proc/sys/kernel/core_pattern and empty current->comm
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible to set /proc/sys/kernel/core_pattern to %e:

	echo '%e' > /proc/sys/kernel/core_pattern


A couple of interesting effects:

a. Cores will tend to try to overwrite the executable.

    Is this considered an issue ?


b. Apparently it seems possible to set current->comm to be empty:

	prctl(PR_SET_NAME, "", 0, 0, 0);

   No core dump is generated since the resulting corename is empty,
   and filp_open() fails.

   Is this considered a defect, or potential security concern ?


c. Consequential to (b), setting /proc/sys/kernel/core_pattern to empty
   and /proc/sys/kernel/core_uses_pid to zero universally prevents
   core dumps.

   I'm wondering if this behaviour is provided intentionally.


Earl

