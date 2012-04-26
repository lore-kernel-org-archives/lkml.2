Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759583Ab2DZWeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 18:34:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45762 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab2DZWeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 18:34:12 -0400
Date: Thu, 26 Apr 2012 15:34:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/4] compiler.h: introduce unused_expression() macro
Message-Id: <20120426153411.8686e0f9.akpm@linux-foundation.org>
In-Reply-To: <20120425112623.26927.43229.stgit@zurg>
References: <20120425112623.26927.43229.stgit@zurg>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2012 15:26:23 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> Sometimes we want to check some expressions correctness in compile-time without
> generating extra code. "(void)(e)" does not work if expression has side-effects.
> This patch introduces macro unused_expression() which helps in this situation.
> 
> Cast to "long" required because sizeof does not work for bit-fields.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> ---
>  include/linux/compiler.h |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index 923d093..46fbda3 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -310,4 +310,6 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
>   */
>  #define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
>  
> +#define unused_expression(e) ((void)(sizeof((__force long)(e))))
> +

btw, please let's not add undocumented stuff, particularly obscure
undocumented stuff.

I typed this in:

--- a/include/linux/compiler.h~compilerh-introduce-unused_expression-macro-fix
+++ a/include/linux/compiler.h
@@ -310,6 +310,11 @@ void ftrace_likely_update(struct ftrace_
  */
 #define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
 
+/*
+ * unused_expression() permits the compiler to check the validity of the
+ * expression but avoids the generation of any code, even if that expression
+ * has side-effects.
+ */
 #define unused_expression(e) ((void)(sizeof((__force long)(e))))
 
 #endif /* __LINUX_COMPILER_H */

but then decided I didn't want to apply the patches (yet?).
