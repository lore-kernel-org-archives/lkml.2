Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab1DLRrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 13:47:22 -0400
Received: from svc.spearhead.de ([85.214.96.164]:59367 "EHLO mx.spearhead.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755659Ab1DLRrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 13:47:21 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Apr 2011 13:47:21 EDT
From: Nicos Gollan <ngollan@spearhead.de>
To: linux-kernel@vger.kernel.org
Subject: Mysterious freezes after 2.6.35, no NMI
Date: Tue, 12 Apr 2011 19:39:59 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.35-trunk-amd64; KDE/4.6.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201104121939.59910.ngollan@spearhead.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

For quite some time now I have serious trouble with any kernel after 2.6.35. I 
am experiencing frequent hard freezes. The system will simply stop responding 
to input and is not reachable via network, which leads to data loss because 
the file system does not get to write back all data (the classical "all my KDE 
config is gone!" symptom).

A quick recap and a bunch of info (dmesg, lspci, other hardware info) can be 
found here:
    https://bugzilla.kernel.org/show_bug.cgi?id=31122

Note that the crashes from static electricity are most likely not related, 
since those lead to a very recognizably different failure mode, the ports are 
not even connected anymore, and the real problem occurs without anything 
touching the case, and I have not experienced the problem with old kernels or 
Windows 7.

At first I suspected the HPET "fixes" in 2.6.36 to be responsible, but the 
instability occurs with HPET disabled by kernel parameter (the BIOS setup does 
not allow to disable it).

To add insult to injury, at least in the 2.6.38 series, the NMI watchdog is 
broken. The counters in /proc/interrupts always show 0, but will count up 
quite happily on 2.6.35.

I'm rather tired of guessing what it might be, the whole thing is very hard to 
diagnose since it can take days until a freeze happens, and I don't really 
want to push my luck so far that I lose important data, but being stuck at 
2.6.35 is not satisfactory in the long run.

I am not subscribed to the list, but I am subscribed to the bug report.

Regards,
Nicos Gollan
