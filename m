Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab0IJPiu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:38:50 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:38200 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab0IJPcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:32:41 -0400
X-SpamScore: -3
X-BigFish: VS-3(zz4015Lzz1202hzz8275dhz32i2a8h87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8JF3Y-02-JPS-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/29] Nested Paging Virtualization for KVM v4
Date: Fri, 10 Sep 2010 17:30:37 +0200
Message-ID: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi, Marcelo,

as promised here is -v4 of my patch-set for virtualizing nested paging in KVM.
I addresses all of your review comments in this version and fixed a misbehavior
in the nested page-walker code where it would have reported the wrong
error-code on an emulated nested page fault.

Here is the complete list of changes:

	* Fixed the bug in the gpa_to_gfn function
	* Made sure that the right fault values are kept in the two-dimensional
	  page-table walker
	* Fixed the return code of x86_decode_insn so that a page-fault within
	  that function can be handled
	* Set vcpu->arch.mmu.direct_map to true for nonpaging mode too
	* Changed code so that the right access-mode is used on nested
	  page-table walks
	* Made the NX mode a capability of the MMU context to distinguish
	  between l1-nx and l2-nx (1 additional patch)
	* Fixed the bug that KVM always reports the SVM flag as supported to
	  userspace, it should only be reported on AMD hardware when nesting is
	  enabled

As the patch-set before this one was tested with the same set of combinations
too. I found no regressions to current avi/master. This patch-set applies on
current avi/master plus the three fixes I sent last week.

As with the last version of the patch-set I also pushed this one to a tree on
korg. Find it in

	git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-kvm.git npt-virt-v4

Please review these patches and/or apply them :-) As usual I appreciate your
feedback.

Thanks,

	Joerg


