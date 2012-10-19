Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab2JSFnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 01:43:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:15521 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab2JSFng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 01:43:36 -0400
X-IronPort-AV: E=Sophos;i="4.80,611,1344182400"; 
   d="scan'208";a="6028295"
Message-ID: <5080E813.7030302@cn.fujitsu.com>
Date: Fri, 19 Oct 2012 13:41:39 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: x86@kernel.org, kexec@lists.infradead.org, Avi Kivity <avi@redhat.com>,
        mtosatti@redhat.com
CC: linux-kernel@vger.kernel.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [PATCH v2 0/2] x86: clear vmcss on all cpus when doing kdump if necessary
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/19 13:42:32,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/19 13:42:32,
	Serialize complete at 2012/10/19 13:42:32
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, kdump just makes all the logical processors leave VMX operation by
executing VMXOFF instruction, so any VMCSs active on the logical processors may
be corrupted. But, sometimes, we need the VMCSs to debug guest images contained
in the host vmcore. To prevent the corruption, we should VMCLEAR the VMCSs before
executing the VMXOFF instruction.

The patch set provides a way to VMCLEAR vmcss related to guests on all cpus before
executing the VMXOFF when doing kdump. This is used to ensure the VMCSs in the
vmcore updated and non-corrupted.

Changelog from v1 to v2:
1. remove the sysctl and clear VMCSs unconditionally.

zhangyanfei (2):
  x86/kexec: VMCLEAR vmcss on all cpus if necessary
  KVM: make crash_clear_loaded_vmcss valid when loading kvm_intel
    module

 arch/x86/include/asm/kexec.h |    2 ++
 arch/x86/kernel/crash.c      |   27 +++++++++++++++++++++++++++
 arch/x86/kvm/vmx.c           |    9 +++++++++
 3 files changed, 38 insertions(+), 0 deletions(-)
