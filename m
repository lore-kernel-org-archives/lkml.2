Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759705Ab2ERV7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 17:59:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:49970 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758481Ab2ERV7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 17:59:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 08/10] Use __kernel_ulong_t in struct msqid64_ds
Date: Fri, 18 May 2012 21:58:59 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Daney <ddaney.cavm@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        mingo@kernel.org, tglx@linutronix.de
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com> <201205182131.29353.arnd@arndb.de> <4FB6C1F7.1010307@zytor.com>
In-Reply-To: <4FB6C1F7.1010307@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205182158.59616.arnd@arndb.de>
X-Provags-ID: V02:K0:ZaJju9ITYRsaT3fI3AOjqgpc7f5swQiIMu2bI3BfUGC
 XiEJTB5OETvRbgVm3X6vf2MI5lBY1aOgA2JGeRsXmqh6q2ePoM
 IAS23ZUU0VC8e3bjq/+q4O5iaZ9QsVpgX/QtjkMaCb0gKJ9ecx
 u+rV8mp/oppoaPSq4i0Qf0xDr61SzrVXuUkfOwdjmPm66KSo49
 cfa3E+U/Z8ahm3iD3rI4qMH6EA2MzcrovPH0vAV9Z47SO0am1w
 VudqDakRwbES/ckdsjd9Qvoi2qpkySNX5sEsW64s7gLne6jQYQ
 qTPpypfX+VeO1/2RMPquvW69hXSHzCy7hH5mgpa5DxCtrQbi5A
 AMCJek5+Zg5606ESWM8E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 May 2012, H. Peter Anvin wrote:
> 
> On 05/18/2012 02:31 PM, Arnd Bergmann wrote:
> > 
> > However, in the kernel we always copy the fields one by one for compat
> > mode, even for the architectures that have identical layout between 32 and
> > 64 bit, and at least one libc implementation that I've seen (IIRC uClibc)
> > hardcodes the data structure to be the same as x86, with the padding
> > after the 'long', for all architectures. When I introduced the asm-generic
> > version of this, we had a discussion about whether we should try to use
> > the version with the "correct" padding but in the end decided to just use
> > the x86 version because that is what most big-endian architectures do
> > anyway.
> > 
> 
> Ouch.  Fail.  asm-generic should be about what is the right thing going
> forward.

But why do you think it's wrong the way it is? I see the idea of putting
padding in varying places depending on the endianess as a failed experiment
and defining a structure that is always the same as the logical conclusion
from that, even if it's a bit silly to have any padding in it at all.

Being consistent seems more important here than following the intent
of whoever came up with the concept of the ipc64 data structures
and was consequently ignored by most people after him.

If we really wanted the data structures to be compatible between 32 and
64 bit mode, we'd have to use __u64 here but that would mean having to
change all bits of user code that already rely on the existing x86
compatible layout.

	Arnd
