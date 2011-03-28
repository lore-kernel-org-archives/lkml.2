Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249Ab1C1Tby (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 15:31:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44239 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab1C1Tbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 15:31:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=brMicJM23uGt8vNmvs/OlJGC652nYZJgMwdbvGlCAJtQHMLe5Z047pa2aQByKg03k2
         wuQtP40qnP/Z+DMlulWlIJnzLMv8280Cy1O2Lh6CDDI1+XZkK0knrqse16NNzCpAtmPt
         D//APm/+jG6AK7KUxEg4/+8u+b/NerZjcF/ag=
Subject: Re: [PATCH v2] x86: page: get_order() optimization
From: Maksym Planeta <mcsim.planeta@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, kernel-janitors@vger.kernel.org, namhyung@gmail.com,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Jan Beulich <JBeulich@novell.com>
In-Reply-To: <20110328050844.GC26322@elte.hu>
References: <1301215556-8898-1-git-send-email-mcsim.planeta@gmail.com>
	 <20110327113323.GA27825@elte.hu> <1301246136.2291.49.camel@debian>
	 <20110328050844.GC26322@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Mar 2011 22:33:42 +0300
Message-ID: <1301340822.6302.90.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28/03/2011 at 07:08 +0200, Ingo Molnar wrote:
> Have you looked at the disassembly, why does the size increase? I'd expect such 
> a straight assembly optimization to result in smaller code: in the non-constant 
> case it should be the same size as before, in the constant case it should be 
> smaller, because BSR should be smaller than an open-coded search loop, right?


Here is disassembly of patched get_order() with "inline" from
"kernel/kexec.c":

     a6c:       48 8b 5d c8             mov    -0x38(%rbp),%rbx
     a70:       e8 0b fd ff ff          callq  780 <get_order.clone.7>

0000000000000780 <get_order.clone.7>:
     780:       55                      push   %rbp
     781:       b8 01 00 00 00          mov    $0x1,%eax
     786:       48 89 e5                mov    %rsp,%rbp
     789:       c9                      leaveq 
     78a:       c3                      retq   

My version of gcc is gcc (Debian 4.5.2-4) 4.5.2, probably I should
upgrade my gcc version for better inline expansions.

-- 
Thanks,

Maksym Planeta

