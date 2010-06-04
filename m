Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab0FDOmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 10:42:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155Ab0FDOmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 10:42:20 -0400
Date: Fri, 4 Jun 2010 10:42:02 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 0/5] kdump: extract log buffer and registers from
	vmcore on NMI button pressing
Message-ID: <20100604144202.GE4111@redhat.com>
References: <1275464359-1566-1-git-send-email-v.mayatskih@gmail.com> <20100602151611.GA3174@redhat.com> <87iq60a3rh.wl%vmayatsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87iq60a3rh.wl%vmayatsk@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 11:01:38AM +0200, Vitaly Mayatskikh wrote:
> At Wed, 2 Jun 2010 11:16:11 -0400, Vivek Goyal wrote:
>  
> > I am not sure what is the problem we are trying to solve here. If we are
> > unable to capture the dump because second kernel did not boot due to
> > some dirver issue etc, above patch is not going to help either.
> > 
> > If kernel has booted, then one should be able to capture the dump, filter
> > it and look at the log buffers and cpu registers.
> > 
> > Most of the failures I have seen in capture kernel is that it was unable
> > to boot due to either deivce issues or failure in early boot. Once it has
> > crossed those hurdles, after that capturing the dump is easy part.
> > 
> > How many times does it happen in second kernel that kernel is spinning in
> > a loop and NMI can still get you information out.
> > 
> > So can you please give some more information about what kind of failures
> > while capturing the dump you are addressing by this patchset.
> 
> Obviously, this change doesn't help if 2nd kernel is not able to
> boot. But there are other problems, which may prevent vmcore to be
> captured. For example, machine has RAM > HDD and it may save vmcore
> only over network. If network fails (e.g., due to bugs in NIC drivers
> or NFS, what is not so rare), and dump capture environment is
> non-interactive, or it doesn't have development tools like `crash',
> there's no chance even to guess what has happened.

Vitaly, in this case it sounds like writting some user space utility to
display log buffers of previous kernel and pack into initrd/initramfs and
run that utility if network is down and hard disk does not have enough
space to store the dump.

I vaguely remember that dump filtering utility was doing something
similar.

> 
> Other possibilities of failure may include broken RAID controller,
> HDD, RAM. NMI button in such situations is a last chance to see old
> log.

Again, can't we do it with the help of user space utility packed in
initrd.

IMHO, somehow NMI button does not sound like a very good option. At max we
probably can look into doing this through sysrq option but I am not too
keen on that also until and unless we have good examples. You mentioned
that one might not be able to log in, but I am wondering why one would not
be able to login.

In kdump initrd, we can create one default policy that if you can't
capture dump, then try to save only log buffers of previous kernel. If
disk is broken, then just dump the buffers on console etc. This assumes
that console are at least being logged or somebody is looking at the
console. If not, one can always login and run the utility to dump buffers
again.

The only corner case which is not covered is that one can not login into
the system and somebody plugged in cosole later or console was shared. I 
am not sure how common that case is.

Making capture kernel print pervious kernel's buffers does not sound very
convincing to me, at this point. I will 

Thanks
Vivek
