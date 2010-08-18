Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836Ab0HRFk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 01:40:29 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:46780 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab0HRFkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 01:40:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tloAwLL9LoboUOAr/wzLxjycb9O/ZLw0sBWsh/GMU4KGfMPk7w3epmRGcZTkhwBPm4
         DB/iI28CvKy7ycKYNv7EoI5jwWyFExJrf9F2KqhaXiqBd6V4GyZPDlI4pIUpdF5mlpsu
         yqRCcC+sqqEKKVWnTwHPLK4RUSZ6Oc2lIDPaw=
Date: Wed, 18 Aug 2010 13:44:37 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: change a temporary variable name in ia32_signal.c
Message-ID: <20100818054437.GC5243@cr0.nay.redhat.com>
References: <1282108520-8723-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282108520-8723-1-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 02:15:20PM +0900, Namhyung Kim wrote:
>This removes following sparse warnings:
>
> ia32_signal.c:240:17: warning: symbol 'tmp' shadows an earlier one
> ia32_signal.c:228:13: originally declared here
> ia32_signal.c:241:17: warning: symbol 'tmp' shadows an earlier one
> ia32_signal.c:228:13: originally declared here
> ia32_signal.c:242:17: warning: symbol 'tmp' shadows an earlier one
> ia32_signal.c:228:13: originally declared here
> ia32_signal.c:243:17: warning: symbol 'tmp' shadows an earlier one
> ia32_signal.c:228:13: originally declared here
> ia32_signal.c:249:17: warning: symbol 'tmp' shadows an earlier one
> ia32_signal.c:228:13: originally declared here
> ia32_signal.c:250:17: warning: symbol 'tmp' shadows an earlier one
> ia32_signal.c:228:13: originally declared here
>
>Signed-off-by: Namhyung Kim <namhyung@gmail.com>


Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.

>---
> arch/x86/ia32/ia32_signal.c |    6 +++---
> 1 files changed, 3 insertions(+), 3 deletions(-)
>
>diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
>index 348928a..6db169d 100644
>--- a/arch/x86/ia32/ia32_signal.c
>+++ b/arch/x86/ia32/ia32_signal.c
>@@ -202,9 +202,9 @@ asmlinkage long sys32_sigaltstack(const stack_ia32_t __user *uss_ptr,
> }
> 
> #define GET_SEG(seg)		({			\
>-	unsigned short tmp;				\
>-	get_user_ex(tmp, &sc->seg);			\
>-	tmp;						\
>+	unsigned short __tmp;				\
>+	get_user_ex(__tmp, &sc->seg);			\
>+	__tmp;						\
> })
> 
> #define COPY_SEG_CPL3(seg)	do {			\
>-- 
>1.7.0.4
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
