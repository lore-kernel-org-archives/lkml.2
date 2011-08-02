Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab1HBTyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 15:54:43 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:58805 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755178Ab1HBTye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 15:54:34 -0400
Date: Tue, 2 Aug 2011 12:54:31 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org
Subject: [PATCH -next] kvm: uses TASKSTATS, depends on NET
Message-Id: <20110802125431.e1902bd1.rdunlap@xenotime.net>
In-Reply-To: <20110802155727.a3d76babdd2c6fd5d33928c5@canb.auug.org.au>
References: <20110802155727.a3d76babdd2c6fd5d33928c5@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

CONFIG_TASKSTATS just had a change to use netlink, including
a change to "depends on NET".  Since "select" does not follow
dependencies, KVM also needs to depend on NET to prevent build
errors when CONFIG_NET is not enabled.

Sample of the reported "undefined reference" build errors:

taskstats.c:(.text+0x8f686): undefined reference to `nla_put'
taskstats.c:(.text+0x8f721): undefined reference to `nla_reserve'
taskstats.c:(.text+0x8f8fb): undefined reference to `init_net'
taskstats.c:(.text+0x8f905): undefined reference to `netlink_unicast'
taskstats.c:(.text+0x8f934): undefined reference to `kfree_skb'
taskstats.c:(.text+0x8f9e9): undefined reference to `skb_clone'
taskstats.c:(.text+0x90060): undefined reference to `__alloc_skb'
taskstats.c:(.text+0x901e9): undefined reference to `skb_put'
taskstats.c:(.init.text+0x4665): undefined reference to `genl_register_family'
taskstats.c:(.init.text+0x4699): undefined reference to `genl_register_ops'
taskstats.c:(.init.text+0x4710): undefined reference to `genl_unregister_ops'
taskstats.c:(.init.text+0x471c): undefined reference to `genl_unregister_family'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 arch/x86/kvm/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next-20110802.orig/arch/x86/kvm/Kconfig
+++ linux-next-20110802/arch/x86/kvm/Kconfig
@@ -22,6 +22,8 @@ config KVM
 	depends on HAVE_KVM
 	# for device assignment:
 	depends on PCI
+	# for TASKSTATS/TASK_DELAY_ACCT:
+	depends on NET
 	select PREEMPT_NOTIFIERS
 	select MMU_NOTIFIER
 	select ANON_INODES
