Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab2BUBVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 20:21:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9557 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab2BUBVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 20:21:12 -0500
X-Authority-Analysis: v=2.0 cv=MaXuSuDf c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=_9QhTkKbWN8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=Z4Rwk6OoAAAA:8 a=oGMlB6cnAAAA:8 a=meVymXHHAAAA:8 a=XZ5eMslrHSyfITZwnU4A:9 a=rw3KkN8m-Z1gU0BTl8MA:7 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jbrJJM5MRmoA:10 a=CY6gl2JlH4YA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1329787271.25686.54.camel@gandalf.stny.rr.com>
Subject: [PATCH v2][GIT PULL][v3.3] x86: Specify a size for the cmp in the
 NMI handler
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 20 Feb 2012 20:21:11 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/x86/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/x86/urgent

Head SHA1: a38449ef596b345e13a8f9b7d5cd9fedb8fcf921


Steven Rostedt (1):
      x86: Specify a size for the cmp in the NMI handler

----
 arch/x86/kernel/entry_64.S |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)
---------------------------
commit a38449ef596b345e13a8f9b7d5cd9fedb8fcf921
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Mon Feb 20 15:29:34 2012 -0500

    x86: Specify a size for the cmp in the NMI handler
    
    Linus noticed that the cmp used to check if the code segment is
    __KERNEL_CS or not did not specify a size. Perhaps it does not matter
    as H. Peter Anvin noted that user space can not set the bottom two
    bits of the %cs register. But it's best not to let the assembly choose
    and change things between different versions of gas, but instead just
    pick the size.
    
    Four bytes are used to compare the saved code segment against
    __KERNEL_CS. Perhaps this might mess up Xen, but we can fix that when
    the time comes.
    
    Also I noticed that there was another non-specified cmp that checks
    the special stack variable if it is 1 or 0. This too probably doesn't
    matter what cmp is used, but this patch uses cmpl just to make it non
    ambiguous.
    
    Link: http://lkml.kernel.org/r/CA+55aFxfAn9MWRgS3O5k2tqN5ys1XrhSFVO5_9ZAoZKDVgNfGA@mail.gmail.com
    
    Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
    Cc: H. Peter Anvin <hpa@zytor.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index debd851..1333d98 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1535,14 +1535,14 @@ ENTRY(nmi)
 	 * If %cs was not the kernel segment, then the NMI triggered in user
 	 * space, which means it is definitely not nested.
 	 */
-	cmp $__KERNEL_CS, 16(%rsp)
+	cmpl $__KERNEL_CS, 16(%rsp)
 	jne first_nmi
 
 	/*
 	 * Check the special variable on the stack to see if NMIs are
 	 * executing.
 	 */
-	cmp $1, -8(%rsp)
+	cmpl $1, -8(%rsp)
 	je nested_nmi
 
 	/*


