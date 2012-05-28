Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab2E1Oh4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 10:37:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899Ab2E1Ohz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 10:37:55 -0400
Message-ID: <4FC38DBD.4070406@redhat.com>
Date: Mon, 28 May 2012 17:37:49 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: triage for April 19, 2012
References: <20120420020013.GA19964@windriver.com> <CAMuHMdUUgysVqz226jhK42nvYNaX7yvexpqRjOPx0QpvzUwVXg@mail.gmail.com>
In-Reply-To: <CAMuHMdUUgysVqz226jhK42nvYNaX7yvexpqRjOPx0QpvzUwVXg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2012 11:59 PM, Geert Uytterhoeven wrote:
> On Fri, Apr 20, 2012 at 4:00 AM, Paul Gortmaker
> <paul.gortmaker@windriver.com> wrote:
>> The parisc got borked by some kvm header shuffle it seems?
>> Now complaining about "file 'asm-generic/kvm_para.h' is not exported"
>> [ http://kisskb.ellerman.id.au/kisskb/buildresult/6137786/ ]
> 
> Not only parisc.
> 
> This breakage has now entered mainline:
> 
> parisc deconfig http://kisskb.ellerman.id.au/kisskb/buildresult/6365677/
> m68k allmodconfig: http://kisskb.ellerman.id.au/kisskb/buildresult/6365681/


Does the following patch help?

I was unable to find a cross compiler, so I can't test it myself.


From: Avi Kivity <avi@redhat.com>
Date: Mon, 28 May 2012 17:35:22 +0300
Subject: [PATCH] KVM: Export asm-generic/kvm_para.h

Prevents build failures on non-KVM archs.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 include/asm-generic/Kbuild |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/asm-generic/Kbuild b/include/asm-generic/Kbuild
index 53f91b1..2c85a0f 100644
--- a/include/asm-generic/Kbuild
+++ b/include/asm-generic/Kbuild
@@ -8,6 +8,7 @@ header-y += int-ll64.h
 header-y += ioctl.h
 header-y += ioctls.h
 header-y += ipcbuf.h
+header-y += kvm_para.h
 header-y += mman-common.h
 header-y += mman.h
 header-y += msgbuf.h

-- 
error compiling committee.c: too many arguments to function
