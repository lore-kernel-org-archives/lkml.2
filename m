Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab2GOM4n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 08:56:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638Ab2GOM4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 08:56:36 -0400
Date: Sun, 15 Jul 2012 15:56:39 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Jacob Pan <jacob.jun.pan@intel.com>,
        Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Joerg Roedel <joerg.roedel@amd.com>, Yinghai Lu <yinghai@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, avi@redhat.com,
        gleb@redhat.com
Subject: [PATCH 0/3] make KVM PV use apic through APIs
Message-ID: <cover.1342356186.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM PV EOI optimization overrides eoi_write apic op with its own
version. at Ingo's suggestion, add an API for this and switch kvm to use
it, to avoid meddling with core x86 apic driver data structures
directly.

Ingo, could you please review and let us know whether this
matches what you had in mind?

This patchset is on top of kvm/next since it touches some
of the code modified in that tree (and patch 3 reverts a commit
in that tree). Could x86 some maintainers pls ACK merging this patchset
through the kvm tree?

Michael S. Tsirkin (3):
  apic: add apic_set_eoi_write for PV use
  kvm: switch to apic_set_eoi_write, apic_write
  Revert "apic: fix kvm build on UP without IOAPIC"

 arch/x86/include/asm/apic.h |  8 +++-----
 arch/x86/kernel/apic/apic.c | 17 +++++++++++++++++
 arch/x86/kernel/kvm.c       | 13 +++----------
 3 files changed, 23 insertions(+), 15 deletions(-)

-- 
MST
