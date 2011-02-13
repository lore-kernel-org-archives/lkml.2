Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab1BMPtz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 10:49:55 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:35543 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab1BMPtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 10:49:53 -0500
X-Greylist: delayed 367 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Feb 2011 10:49:53 EST
Date: Sun, 13 Feb 2011 15:43:43 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Florian Weimer <fw@deneb.enyo.de>
cc: "H.J. Lu" <hjl.tools@gmail.com>, x32-abi@googlegroups.com,
        GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: X32 psABI status
In-Reply-To: <87tyg8j7le.fsf@mid.deneb.enyo.de>
Message-ID: <alpine.LFD.2.00.1102131514250.31425@eddie.linux-mips.org>
References: <AANLkTikgfv+L9WS4s6n5mQcXWTzc6YMNUSsgBiAOmKbE@mail.gmail.com>        <87aai1gdr7.fsf@mid.deneb.enyo.de> <4D5711E0.7020306@zytor.com>        <87r5bcnwvw.fsf@mid.deneb.enyo.de>        <AANLkTi=Ybzkp_NHom==M-kL+URWmmZ1LoWVP-EYMkN-j@mail.gmail.com>
 <87tyg8j7le.fsf@mid.deneb.enyo.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Feb 2011, Florian Weimer wrote:

> >> Actually, I'm wondering if you can do the translation in user space.
> >> There already are 32-on-64 implementations in existence, without
> >> kernel changes (recent Hotspot, LuaJIT, and probably some more).
> >
> > Please check out the x32 kernel source and provide feedback.
> 
> I still don't understand why you need a separate syscall table.  You
> should really be able to run on an unmodified amd64 kernel, in 64 bit
> mode.  This would imply that tools like strace don't need any porting
> at all (you could just use the amd64 version), and even GDB would
> mostly worked unchanged.

 For the record -- I suggested a similar approach for n32 MIPS too (back 
when it was on the table), but people rejected it deciding it was easier 
for them to add a separate syscall table (for a change).  It was perhaps 
even more surprising as any MIPS 32-bit user pointer is a valid 64-bit one 
too (I suspect this is also the case with x86-64) and any simple type, 
including pointers and the "long long" type (such as used with lseek64(2), 
etc.) goes into a single 64-bit register or stack slot with both ABIs, so 
any conversion layer (boundary checks or whatever; structures can be 
sorted out with padding) in libc would be pretty thin.

 One argument in favour was the need of some people for crippled 
interfaces such as original lseek(2) that would fail on large files for 
the sake of some broken programs out there they wanted to rebuild for the 
new ABI without fixing, sigh...  Actually some OSes, such as NetBSD (I 
think, it could have been one of the other *BSDs), do not offer these 
crippled interfaces at all on any platform, but I gather people simply are 
not particularly interested into pushing portability that far.

 So now we have another table in the kernel to maintain that goes wrong in 
respect to the two others from time to time.  But there you go...  At 
least each of the three is optional.  I couldn't care less about n32 
anyway; I usually configure 64-bit MIPS kernels for n64 only.

  Maciej
