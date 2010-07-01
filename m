Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab0GASLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:11:45 -0400
Received: from kroah.org ([198.145.64.141]:60118 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755435Ab0GASK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:10:59 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:28:58 2010
Message-Id: <20100701172858.131219673@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:27:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Helge Deller <deller@gmx.de>, Kyle McMartin <kyle@mcmartin.ca>
Subject: [20/23] parisc: clear floating point exception flag on SIGFPE signal
In-Reply-To: <20100701175134.GA2098@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Helge Deller <deller@gmx.de>

commit 550f0d922286556c7ea43974bb7921effb5a5278 upstream.

Clear the floating point exception flag before returning to
user space. This is needed, else the libc trampoline handler
may hit the same SIGFPE again while building up a trampoline
to a signal handler.

Fixes debian bug #559406.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/parisc/math-emu/decode_exc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/parisc/math-emu/decode_exc.c
+++ b/arch/parisc/math-emu/decode_exc.c
@@ -342,6 +342,7 @@ decode_fpu(unsigned int Fpu_register[],
 		return SIGNALCODE(SIGFPE, FPE_FLTINV);
 	  case DIVISIONBYZEROEXCEPTION:
 		update_trap_counts(Fpu_register, aflags, bflags, trap_counts);
+		Clear_excp_register(exception_index);
 	  	return SIGNALCODE(SIGFPE, FPE_FLTDIV);
 	  case INEXACTEXCEPTION:
 		update_trap_counts(Fpu_register, aflags, bflags, trap_counts);


