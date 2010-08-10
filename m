Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630Ab0HJVpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 17:45:04 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62135 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932516Ab0HJVo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 17:44:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=kmobLTBzlAbOCaiRLfU4CCpSLtmFkIPkyaIryV9DzCLdsECSUbu4x6sztVXf80cp3O
         5Om8P1jU6A+QOpUea2a1bEGFHtlwq7yR8pkSx71CRwAJov2ZC7zMDN3hnW/X5BSK4cDt
         3bxOOU2Xa11s8GgJ0RjKGxcO6Pv2GgwuYRqPo=
Message-ID: <4C61C857.50308@suse.cz>
Date: Tue, 10 Aug 2010 23:44:55 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Chris Metcalf <cmetcalf@tilera.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT] writable_limits for 2.6.36
References: <4C5D4E50.5050105@suse.cz> <AANLkTimPS_WFvEwyx+odwof5_AF5ZTOhu-3uK6m_VhYa@mail.gmail.com> 	<4C617C94.5010808@tilera.com> <201008102050.12558.arnd@arndb.de> <AANLkTi=0nx-HO7Pyun6OCygpjcwP-1aZ+U6XjxEiz_eR@mail.gmail.com> <4C61ABEA.9090104@tilera.com>
In-Reply-To: <4C61ABEA.9090104@tilera.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2010 09:43 PM, Chris Metcalf wrote:
> On 8/10/2010 3:12 PM, Linus Torvalds wrote:
>> So I just moved the prlimit64() system call, both on x86[-64] and in
>> asm-generic/unistd.h
>>
>> Pushed out. Guys, please verify that it looks ok.
>>   
> 
> It looks good in asm-generic/unistd.h; thanks.

To me too, except the nits below.

---
 arch/x86/ia32/ia32entry.S          |    2 +-
 arch/x86/kernel/syscall_table_32.S |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 91dc4bb..b9472ec 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -844,5 +844,5 @@ ia32_sys_call_table:
        .quad compat_sys_recvmmsg
        .quad sys_fanotify_init
        .quad sys32_fanotify_mark
-       .quad sys_prlimit64
+       .quad sys_prlimit64                     /* 340 */
 ia32_syscall_end:
diff --git a/arch/x86/kernel/syscall_table_32.S
b/arch/x86/kernel/syscall_table_32.S
index 4802acc..b35786d 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -339,4 +339,4 @@ ENTRY(sys_call_table)
        .long sys_recvmmsg
        .long sys_fanotify_init
        .long sys_fanotify_mark
-       .long sys_prlimit64
+       .long sys_prlimit64             /* 340 */

