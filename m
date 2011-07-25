Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab1GYSBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 14:01:13 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:46981 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751392Ab1GYSBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 14:01:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Sy95Vqd75oNb5WBGHOUCRaeUObrIosFVO5RPZfq7adPCoUYmzc0uT5h9xD0qpedzEVXjX5mszfuZwBZQZ5Gz8dsW6EFH/q2z7ZhX1cIktA7Y6DCeyLyiFRREaeaQKerq;
Date: Mon, 25 Jul 2011 11:01:09 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, akpm <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, x86@kernel.org
Subject: [PATCH -next] kvm: fix TASK_DELAY_ACCT kconfig warning
Message-Id: <20110725110109.b06fe691.rdunlap@xenotime.net>
In-Reply-To: <20110725162542.39ea8d8cbd51604523635c1a@canb.auug.org.au>
References: <20110725162542.39ea8d8cbd51604523635c1a@canb.auug.org.au>
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

Fix kconfig dependency warning:

warning: (KVM) selects TASK_DELAY_ACCT which has unmet direct dependencies (TASKSTATS)

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 arch/x86/kvm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20110725.orig/arch/x86/kvm/Kconfig
+++ linux-next-20110725/arch/x86/kvm/Kconfig
@@ -31,6 +31,7 @@ config KVM
 	select KVM_ASYNC_PF
 	select USER_RETURN_NOTIFIER
 	select KVM_MMIO
+	select TASKSTATS
 	select TASK_DELAY_ACCT
 	---help---
 	  Support hosting fully virtualized guest machines using hardware
