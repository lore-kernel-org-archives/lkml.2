Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab0DVWHY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 18:07:24 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:44813 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab0DVWHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 18:07:22 -0400
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Neil Horman <nhorman@tuxdriver.com>, Cong Wang <amwang@redhat.com>,
       kexec@lists.infradead.org
Subject: Re: [PATCH 0/5] Add second memory region for crash kernel
References: <1271953392-6324-1-git-send-email-v.mayatskih@gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 22 Apr 2010 15:07:11 -0700
In-Reply-To: <1271953392-6324-1-git-send-email-v.mayatskih@gmail.com> (Vitaly Mayatskikh's message of "Thu\, 22 Apr 2010 18\:23\:07 +0200")
Message-ID: <m1aasvkupc.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: v.mayatskih@gmail.com, kexec@lists.infradead.org, amwang@redhat.com, nhorman@tuxdriver.com, hbabu@us.ibm.com, vgoyal@redhat.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vitaly Mayatskikh <v.mayatskih@gmail.com> writes:

> Patch applies to 2.6.34-rc5
>
> On x86 platform, even if hardware is 64-bit capable, kernel starts
> execution in 32-bit mode. When system is kdump-enabled, crashed kernel
> switches to 32 bit mode and jumps into new kernel. This automatically
> limits location of dump-capture kernel image and it's initrd by first
> 4Gb of memory. Switching to 32 bit mode is performed by purgatory
> code, which has relocations of type R_X86_64_32S (32-bit signed), and
> this cuts "good" address space for crash kernel down to 2 Gb. I/O
> regions may cut down this space further.
>
> When system has a lot of memory (hundreds of gigabytes), dump-capture
> kernel also needs relatively a lot of memory to account old kernel's
> pages. It may be impossible to reserve enough memory below 2 or even 4
> Gb. Simplest solution is it break dump-capture kernel's reserved
> memory region into two pieces: first (small) region for kernel and
> initrd images may be easily placed in "good" address space in the
> beginning of physical memory, and second region may be located
> anywhere.
>
> This serie of patches realizes this approach. It requires also changes
> in kexec utility to make this feature work, but is
> backward-compatible: old versions of kexec will work with new
> kernel. I will post patch to kexec-tools upstream separately.

Have you tried loading a 64bit vmlinux directly into a higher address
range?  There may be a bit or two missing but you should be able to
load a linux kernel above 4GB.  I tested the basics of that mechanism
when I made the 64bit relocatable kernel.

I don't buy the argument that there is a direct connection between
the amount of memory you have and how much memory it takes to dump it.
Even an indirect connections seems suspicious.

Eric
