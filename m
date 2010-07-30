Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706Ab0G3STB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:19:01 -0400
Received: from kroah.org ([198.145.64.141]:58813 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760027Ab0G3R4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:56:37 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:45 2010
Message-Id: <20100730175145.035778100@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:52:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roland McGrath <roland@redhat.com>
Subject: [122/205] x86: kprobes: fix swapped segment registers in kretprobe
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roland McGrath <roland@redhat.com>

commit a197479848a2f1a2a5c07cffa6c31ab5e8c82797 upstream.

In commit f007ea26, the order of the %es and %ds segment registers
got accidentally swapped, so synthesized 'struct pt_regs' frames
have the two values inverted.  It's almost sure that these values
never matter, and that they also never differ.  But wrong is wrong.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/kprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -632,8 +632,8 @@ static int __kprobes kprobe_handler(stru
 	/* Skip cs, ip, orig_ax and gs. */	\
 	"	subl $16, %esp\n"	\
 	"	pushl %fs\n"		\
-	"	pushl %ds\n"		\
 	"	pushl %es\n"		\
+	"	pushl %ds\n"		\
 	"	pushl %eax\n"		\
 	"	pushl %ebp\n"		\
 	"	pushl %edi\n"		\


