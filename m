Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab1EHV6Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 17:58:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42853 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab1EHV6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 17:58:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=S9t0sUAcXPfNgusgBaovVdO1DRn8hXUgmYK1ODIdnPZ5qWwRTEhvBodrQKxX3EdDql
         yLC9VeH9fsj+ZXEL8pEE745th00SbDAVYLaW08Y+Rqxz3bHA+6/yki0XJfu4+zYt+/Ci
         STt5LDQCeMhBnyNnu1qOQW4p6CyPetOzQaSUk=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 04/11] ptrace: implement PTRACE_INTERRUPT
Date: Sun, 8 May 2011 23:58:20 +0200
User-Agent: KMail/1.8.2
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
References: <1304869745-1073-1-git-send-email-tj@kernel.org> <1304869745-1073-5-git-send-email-tj@kernel.org>
In-Reply-To: <1304869745-1073-5-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201105082358.20159.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 May 2011 17:48, Tejun Heo wrote:
> Currently, there's no way to trap a running ptracee short of sending a
> signal which has various side effects.  This patch implements
> PTRACE_INTERRUPT which traps ptracee without any signal or job control
> related side effect.

What are the rules for the userspace? You said about PTRACE_SEIZE:

> After PTRACE_SEIZE, tracee will trap.  Which trap will happen isn't
> fixed.  If other trap conditions exist (signal delivery or group
> stop), they might be taken; otherwise, a trap with exit_code SIGTRAP |
> (PTRACE_EVENT_INTERRUPT << 8) is taken.  The followings are
> guaranteed.
> 
> * A trap will happen in finite amount of userland time.
> 
> * The trap can be PTRACE_EVENT_INTERRUPT which doesn't have any side
>   effect.  If a different trap is taken, no INTERRUPT trap is pending.
> 
> IOW, no matter what, one trap will happen, which might be INTERRUPT.

Are rules for PTRACE_INTERRUPT the same? That is, what happens
if a different trap is taken?

Can you add API notes in the header, above corresponding defines? -

--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -48,6 +48,7 @@
 #define PTRACE_SETREGSET       0x4205
 
<============================================ ADD COMMENT HERE
 #define PTRACE_SEIZE           0x4206
<============================================ ADD COMMENT HERE
+#define PTRACE_INTERRUPT       0x4207


They will be much more visible and up-to-date there than in Documentation,
git logs etc...

And finally, thanks for working on the long-needed evolutionary fixes to ptrace!

-- 
vda
