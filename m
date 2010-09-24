Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817Ab0IXQdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:33:43 -0400
Received: from kroah.org ([198.145.64.141]:38472 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932719Ab0IXQ2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:44 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:19 2010
Message-Id: <20100924162619.838771152@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, avi@redhat.com,
        mtosatti@redhat.com, Gleb Natapov <gleb@redhat.com>
Subject: [57/80] KVM: x86: emulator: inc/dec can have lock prefix
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Gleb Natapov <gleb@redhat.com>

commit c0e0608cb902af1a1fd8d413ec0a07ee1e62c652 upstream.

Mark inc (0xfe/0 0xff/0) and dec (0xfe/1 0xff/1) as lock prefix capable.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/emulate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -345,10 +345,10 @@ static u32 group_table[] = {
 	DstMem | SrcNone | ModRM, DstMem | SrcNone | ModRM,
 	0, 0, 0, 0,
 	[Group4*8] =
-	ByteOp | DstMem | SrcNone | ModRM, ByteOp | DstMem | SrcNone | ModRM,
+	ByteOp | DstMem | SrcNone | ModRM | Lock, ByteOp | DstMem | SrcNone | ModRM | Lock,
 	0, 0, 0, 0, 0, 0,
 	[Group5*8] =
-	DstMem | SrcNone | ModRM, DstMem | SrcNone | ModRM,
+	DstMem | SrcNone | ModRM | Lock, DstMem | SrcNone | ModRM | Lock,
 	SrcMem | ModRM | Stack, 0,
 	SrcMem | ModRM | Stack, SrcMem | ModRM | Src2Mem16 | ImplicitOps,
 	SrcMem | ModRM | Stack, 0,


