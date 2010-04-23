Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab0DWOpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 10:45:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753939Ab0DWOpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 10:45:10 -0400
Date: Fri, 23 Apr 2010 10:44:52 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vitaly Mayatskikh <v.mayatskih@gmail.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Haren Myneni <hbabu@us.ibm.com>,
       Neil Horman <nhorman@tuxdriver.com>, Cong Wang <amwang@redhat.com>,
       kexec@lists.infradead.org
Subject: Re: [PATCH 0/5] Add second memory region for crash kernel
Message-ID: <20100423144452.GB5026@redhat.com>
References: <1271953392-6324-1-git-send-email-v.mayatskih@gmail.com> <m1aasvkupc.fsf@fess.ebiederm.org> <20100422224525.GJ3228@redhat.com> <m1eii7j8ne.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1eii7j8ne.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 05:48:53PM -0700, Eric W. Biederman wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > On Thu, Apr 22, 2010 at 03:07:11PM -0700, Eric W. Biederman wrote:
> >> Vitaly Mayatskikh <v.mayatskih@gmail.com> writes:
> >> >
> >> > This serie of patches realizes this approach. It requires also changes
> >> > in kexec utility to make this feature work, but is
> >> > backward-compatible: old versions of kexec will work with new
> >> > kernel. I will post patch to kexec-tools upstream separately.
> >> 
> >> Have you tried loading a 64bit vmlinux directly into a higher address
> >> range?  There may be a bit or two missing but you should be able to
> >> load a linux kernel above 4GB.  I tested the basics of that mechanism
> >> when I made the 64bit relocatable kernel.
> >
> > I guess even if it works, for distributions it will become additional
> > liability to carry vmlinux (instead of relocatable bzImage). So we shall
> > have to find a way to make bzImage work.
> 
> As Peter pointed out we actually have everything thing we need except
> a bit of documentation and the flag that says this is a 64bit kernel.
> 
> >From a testing perspective a 64bit vmlinux should work today without
> changes.  Once it is confirmed there is a solution with the 64bit
> kernel we just need a small patch to boot.txt and a few tweaks to 
> /sbin/kexec to handle a 64bit bzImage.
> 

Agreed. Doing little more testing and fixing some issues, if need be, and
making 64 bzImage work is the better way instead of splitting the reserved
memory.
 
Thanks
Vivek
