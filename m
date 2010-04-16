Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558Ab0DPVrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 17:47:14 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:46426 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932420Ab0DPVrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 17:47:12 -0400
Date: Fri, 16 Apr 2010 17:46:53 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull request] ACPI patch for 2.6.34-rc4
Message-id: <alpine.LFD.2.00.1004161745410.4449@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

fixes a popular 2.6.34-rc4 regression.

This will update the files shown below.

thanks!

--
Len Brown
Intel Open Source Technology Center


ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/2.6.34/acpi-release-20100121-2.6.34-rc4.diff.gz

 drivers/acpi/acpica/exprep.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

through these commits:

Alexey Starikovskiy (1):
      ACPI: EC: Limit burst to 64 bits

with this log:

commit bc3966921ff9528ae44a4a108085ab06107c1e7d
Merge: dc57da3 2060c44
Author: Len Brown <len.brown@intel.com>
Date:   Fri Apr 16 16:08:07 2010 -0400

    Merge branch 'bugzilla-15749' into release

commit 2060c44576c79086ff24718878d7edaa7384a985
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Fri Apr 16 15:36:40 2010 -0400

    ACPI: EC: Limit burst to 64 bits
    
    access_bit_width field is u8 in ACPICA, thus 256 value written to it
    becomes 0, causing divide by zero later.
    
    Proper fix would be to remove access_bit_width at all, just because
    we already have access_byte_width, which is access_bit_width / 8.
    Limit access width to 64 bit for now.
    
    https://bugzilla.kernel.org/show_bug.cgi?id=15749
    fixes regression caused by the fix for:
    https://bugzilla.kernel.org/show_bug.cgi?id=14667
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>
