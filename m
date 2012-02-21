Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab2BUAEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 19:04:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38929 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754278Ab2BUAEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 19:04:10 -0500
References: <1329781367.25686.45.camel@gandalf.stny.rr.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <1329781367.25686.45.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][GIT PULL][v3.3] x86: Specify a size for the cmp in the NMI handler
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 20 Feb 2012 16:03:34 -0800
To: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <d3bc5132-98b4-485b-b400-5046350b7ccf@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You can use cmpl here... the segment is only a 16-bit number.  Or use testb $3,...

Steven Rostedt <rostedt@goodmis.org> wrote:

>
>Ingo,
>
>Please pull the latest tip/x86/urgent tree, which can be found at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
>tip/x86/urgent
>
>Head SHA1: 869d49dc575a9cf7041e535ea4911a511bbee764
>
>
>Steven Rostedt (1):
>      x86: Specify a size for the cmp in the NMI handler
>
>----
> arch/x86/kernel/entry_64.S |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
>---------------------------
>commit 869d49dc575a9cf7041e535ea4911a511bbee764
>Author: Steven Rostedt <srostedt@redhat.com>
>Date:   Mon Feb 20 15:29:34 2012 -0500
>
>    x86: Specify a size for the cmp in the NMI handler
>    
>    Linus noticed that the cmp used to check if the code segment is
>  __KERNEL_CS or not did not specify a size. Perhaps it does not matter
>    as H. Peter Anvin noted that user space can not set the bottom two
> bits of the %cs register. But it's best not to let the assembly choose
>  and change things between different versions of gas, but instead just
>    pick the size.
>    
>    The full 8 bytes is used to compare the saved code segment against
>  __KERNEL_CS. Perhaps this might mess up Xen, but we can fix that when
>    the time comes.
>    
>    Also I noticed that there was another non-specified cmp that checks
>  the special stack variable if it is 1 or 0. This too probably doesn't
>  matter what cmp is used, but this patch uses cmpl just to make it non
>    ambiguous.
>    
>Link:
>http://lkml.kernel.org/r/CA+55aFxfAn9MWRgS3O5k2tqN5ys1XrhSFVO5_9ZAoZKDVgNfGA@mail.gmail.com
>    
>    Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
>    Cc: H. Peter Anvin <hpa@zytor.com>
>    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>
>diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
>index debd851..666f2cb 100644
>--- a/arch/x86/kernel/entry_64.S
>+++ b/arch/x86/kernel/entry_64.S
>@@ -1535,14 +1535,14 @@ ENTRY(nmi)
> 	 * If %cs was not the kernel segment, then the NMI triggered in user
> 	 * space, which means it is definitely not nested.
> 	 */
>-	cmp $__KERNEL_CS, 16(%rsp)
>+	cmpq $__KERNEL_CS, 16(%rsp)
> 	jne first_nmi
> 
> 	/*
> 	 * Check the special variable on the stack to see if NMIs are
> 	 * executing.
> 	 */
>-	cmp $1, -8(%rsp)
>+	cmpl $1, -8(%rsp)
> 	je nested_nmi
> 
> 	/*

-- 
Sent from my mobile phone. Please excuse my brevity and lack of formatting.
