Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab2JLGmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 02:42:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:4342 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751477Ab2JLGmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 02:42:08 -0400
X-IronPort-AV: E=Sophos;i="4.80,576,1344182400"; 
   d="scan'208";a="5988189"
Message-ID: <5077BB7B.4030203@cn.fujitsu.com>
Date: Fri, 12 Oct 2012 14:40:59 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: x86@kernel.org, kexec@lists.infradead.org, linux-doc@vger.kernel.org,
        Avi Kivity <avi@redhat.com>, mtosatti@redhat.com
CC: linux-kernel@vger.kernel.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [PATCH 0/3] x86: clear vmcss on all cpus when doing kdump if necessary
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/12 14:41:53,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/12 14:41:54,
	Serialize complete at 2012/10/12 14:41:54
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

The patch set provides an alternative way to clear VMCSs related to guests
on all cpus when host is doing kdump.

zhangyanfei (3):
  x86/kexec: clear vmcss on all cpus if necessary
  KVM: make crash_clear_loaded_vmcss valid when kvm_intel is loaded
  sysctl: introduce a new interface to control kdump-vmcs-clear
    behaviour

 Documentation/sysctl/kernel.txt |    8 ++++++++
 arch/x86/include/asm/kexec.h    |    3 +++
 arch/x86/kernel/crash.c         |   23 +++++++++++++++++++++++
 arch/x86/kvm/vmx.c              |    9 +++++++++
 kernel/sysctl.c                 |   10 ++++++++++
 5 files changed, 53 insertions(+), 0 deletions(-)
