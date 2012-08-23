Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab2HWXOa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 19:14:30 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:52793 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061Ab2HWXO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 19:14:28 -0400
Subject: [PATCH RFC 0/3] Add guest cpu_entitlement reporting
To: linux-kernel@vger.kernel.org
From: Michael Wolf <mjw@linux.vnet.ibm.com>
Cc: kvm@vger.kernel.org, peterz@infradead.org, mtosatti@redhat.com,
        glommer@parallels.com, mingo@redhat.com, avi@redhat.com
Date: Thu, 23 Aug 2012 18:14:20 -0500
Message-ID: <20120823231346.11681.1502.stgit@lambeau>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082323-9360-0000-0000-000009C7DC72
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an RFC regarding the reporting of stealtime.  In the case of
where you have a system that is running with partial processors such as
KVM the user may see steal time being reported in accounting tools such
as top or vmstat.  This can cause confusion for the end user.  To
ease the confusion this patch set adds a sysctl interface to set the
cpu entitlement.  This is the percentage of cpu that the guest system is
 expected to receive.  As long as the steal time is within its expected
range it will show up as 0 in /proc/stat.  The user will then see in the
accounting tools that they are getting a full utilization of the cpu
resources assigned to them.

This patchset is changing the contents/output of /proc/stat and could affect 
user tools.  However the default setting is that the cpu is entitled to 100% 
so the code will act as before.  Also another field could be added to the 
/proc/stat output and show the unaltered steal time. Since this additional 
field could cause more confusion than it would clear up I have left it out 
for now.
                
Michael Wolf (3):
      Add a sysctl interface to control the cpu entitlement setting.
      Add a hypercall to retrieve the cpu entitlement value from the host.
      Modify the amount of stealtime that the kernel reports via the /proc

---
Documentation/sysctl/kernel.txt |   14 +++++++
 arch/x86/kvm/x86.c              |    8 ++++
 fs/proc/stat.c                  |   80 ++++++++++++++++++++++++++++++++++++++-
 include/linux/kernel_stat.h     |    2 +
 include/linux/kvm.h             |    3 ++
 include/linux/kvm_host.h        |    3 ++
 include/linux/kvm_para.h        |    1 +
 kernel/sysctl.c                 |   10 +++++
 virt/kvm/kvm_main.c             |    7 ++++
 9 files changed, 126 insertions(+), 2 deletions(-)

