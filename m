Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781Ab1CBXXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 18:23:22 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:54345 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab1CBXXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 18:23:20 -0500
Date: Wed, 02 Mar 2011 18:22:56 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] ACPI patches for 2.6.38-rc7
Message-id: <alpine.LFD.2.02.1103021821240.12344@x980>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This will update the files shown below.

thanks!
Len Brown
Intel Open Source Technology Center

 drivers/acpi/acpica/aclocal.h |    7 +++++-
 drivers/acpi/acpica/evgpe.c   |   17 ++++++++++++---
 drivers/acpi/acpica/evxfgpe.c |   42 ++++++++++++++++++++++++++++++++--------
 drivers/acpi/debugfs.c        |   20 +++++++++++++-----
 4 files changed, 66 insertions(+), 20 deletions(-)

through these commits:

Rafael J. Wysocki (1):
      ACPI / ACPICA: Implicit notify for multiple devices

Vasiliy Kulikov (1):
      ACPI / debugfs: Fix buffer overflows, double free

with this log:

commit 981858bd7a401aa9607d9f430d5de920025fc3ea
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Feb 24 19:59:21 2011 +0100

    ACPI / ACPICA: Implicit notify for multiple devices
    
    Commit bba63a2 (ACPICA: Implicit notify support) introduced a
    mechanism that causes a notify request of type
    ACPI_NOTIFY_DEVICE_WAKE to be queued automatically by
    acpi_ev_asynch_execute_gpe_method() for the device whose _PRW points
    to the GPE being handled if that GPE is not associated with an
    _Lxx/_Exx method.  However, it turns out that on some systems there
    are multiple devices with _PRW pointing to the same GPE without
    _Lxx/_Exx and the mechanism introduced by commit bba63a2 needs to be
    extended so that "implicit" notify requests of type
    ACPI_NOTIFY_DEVICE_WAKE can be queued automatically for all those
    devices at the same time.
    
    Reported-and-tested-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

commit 2949ad50711cc161721cf788711722eeeca33764
Author: Vasiliy Kulikov <segoon@openwall.com>
Date:   Sat Feb 19 14:18:08 2011 +0100

    ACPI / debugfs: Fix buffer overflows, double free
    
    File position is not controlled, it may lead to overwrites of arbitrary
    kernel memory.  Also the code may kfree() the same pointer multiple
    times.
    
    One more flaw is still present: if multiple processes open the file then
    all 3 static variables are shared, leading to various race conditions.
    They should be moved to file->private_data.
    
    Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
    Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
    Reviewed-by: Eugene Teo <eugeneteo@kernel.org>
    Cc: stable@kernel.org
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
