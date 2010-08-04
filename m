Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612Ab0HDKu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 06:50:57 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:6247 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295Ab0HDKu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 06:50:56 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz4015Lzz1202hzzz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L6MJBD-02-0VS-02
X-M-MSG: 
Date: Wed, 4 Aug 2010 12:47:38 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: [GIT PULL] oprofile: updates for v2.6.34
Message-ID: <20100804104738.GJ26154@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Mailer: git-send-email 1.6.6
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

please pull oprofile updates for v2.6.36:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core

It's just a small number of patches, see the log below. The branch is
already in linux-next for a long time.

Thanks,

-Robert

$ git log --stat --first-parent cc49b092d308f8ea8634134b0d95d831a88a674b..729419f0090601406abe714c5f8872a3bd53ff68 | cat
commit 729419f0090601406abe714c5f8872a3bd53ff68
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Wed Jul 7 17:40:13 2010 -0400

    oprofile: make event buffer nonseekable
    
    The event buffer cannot deal with seeks, so
    we should forbid that outright.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Cc: Robert Richter <robert.richter@amd.com>
    Cc: oprofile-list@lists.sf.net
    Signed-off-by: Robert Richter <robert.richter@amd.com>

 drivers/oprofile/event_buffer.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

commit b12eab1a796a306caef7046b21a76efa35f5f489
Author: Denis Kirjanov <dkirjanov@hera.kernel.org>
Date:   Tue Jun 1 15:43:34 2010 -0400

    powerpc/oprofile: fix potential buffer overrun in op_model_cell.c
    
    Fix potential initial_lfsr buffer overrun.
    Writing past the end of the buffer could happen when index == ENTRIES
    
    Signed-off-by: Denis Kirjanov <dkirjanov@kernel.org>
    Cc: stable@kernel.org
    Signed-off-by: Robert Richter <robert.richter@amd.com>

 arch/powerpc/oprofile/op_model_cell.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

commit d8a382d2662822248a97ce9d670b90e68aefbd3a
Merge: 45c34e0 c6df8d5
Author: Robert Richter <robert.richter@amd.com>
Date:   Fri Jun 4 11:33:10 2010 +0200

    Merge remote branch 'tip/perf/urgent' into oprofile/urgent

commit 45c34e05c4e3d36e7c44e790241ea11a1d90d54e
Author: John Villalovos <sodarock@gmail.com>
Date:   Fri May 7 12:41:40 2010 -0400

    Oprofile: Change CPUIDS from decimal to hex, and add some comments
    
    Back when the patch was submitted for "Add Xeon 7500 series support to
    oprofile", Robert Richter had asked for a followon patch that
    converted all the CPU ID values to hex.
    
    I have done that here for the "i386/core_i7" and "i386/atom" class
    processors in the ppro_init() function and also added some comments on
    where to find documentation on the Intel processors.
    
    Signed-off-by: John L. Villalovos <john.l.villalovos@intel.com>
    Signed-off-by: Robert Richter <robert.richter@amd.com>

 arch/x86/oprofile/nmi_int.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

