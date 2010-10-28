Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964Ab0J1OSz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 10:18:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755199Ab0J1OSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 10:18:51 -0400
Date: Thu, 28 Oct 2010 10:17:57 -0400
From: Jason Baron <jbaron@redhat.com>, rth@redhat.com
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: rostedt@goodmis.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
        tony@bakeyournoodle.com, ddaney@caviumnetworks.com, dsd@laptop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] jump label: disable due to compiler bug
Message-ID: <20101028141757.GA2875@redhat.com>
References: <cover.1288212485.git.jbaron@redhat.com> <2d1b1d5d2b3930e1acb063cefffbcb2faf049854.1288212486.git.jbaron@redhat.com> <ce4ff595-f9d1-4c17-b68e-82739b07ad3e@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce4ff595-f9d1-4c17-b68e-82739b07ad3e@email.android.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 03:21:55PM -0700, H. Peter Anvin wrote:
> Could you detail the bug, please?  static_cpu_has() also uses asm goto.
> 

It seems that gcc can leave the stack in an inconsistent state.

I only saw this in the 'jmp' enabled case, I'm not sure if it can occur in the
straight-line code path as well.

thanks,

-Jason

> "Jason Baron" <jbaron@redhat.com> wrote:
> 
> >Unfortunately, we found a compiler bug in the implementation of
> >'asm goto'. The bug can cause the kernel to crash.
> >
> >For now, we are disabling jump labels with a big hammer. When the
> >gcc fix is committed, we will update the kernel with a better check
> >for either the version number it's fix in, or some detection of
> >whether gcc has the fix in place.
> >
> >Signed-off-by: Jason Baron <jbaron@redhat.com>
> >---
> > include/linux/jump_label.h |    9 +++++++++
> > 1 files changed, 9 insertions(+), 0 deletions(-)
> >
> >diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
> >index b67cb18..954462a 100644
> >--- a/include/linux/jump_label.h
> >+++ b/include/linux/jump_label.h
> >@@ -1,11 +1,20 @@
> > #ifndef _LINUX_JUMP_LABEL_H
> > #define _LINUX_JUMP_LABEL_H
> > 
> >+/*
> >+ * A compiler bug was found in the implementation of 'asm goto'. Thus,
> >+ * we are disabling it for now pending a better check for compiler
> >version
> >+ * that fixes it.
> >+ */
> >+#if 0
> >+
> > #if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_HAVE_ARCH_JUMP_LABEL)
> > # include <asm/jump_label.h>
> > # define HAVE_JUMP_LABEL
> > #endif
> > 
> >+#endif
> >+
> > enum jump_label_type {
> > 	JUMP_LABEL_ENABLE,
> > 	JUMP_LABEL_DISABLE
> >-- 
> >1.7.1
> 
> -- 
> Sent from my mobile phone.  Please pardon any lack of formatting.
