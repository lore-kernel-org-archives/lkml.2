Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465Ab1DCAB7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 20:01:59 -0400
Received: from relay1.sgi.com ([192.48.179.29]:36799 "HELO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756413Ab1DCAB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 20:01:58 -0400
Date: Sat, 2 Apr 2011 19:01:53 -0500
From: Russ Anderson <rja@sgi.com>
To: Valdis.Kletnieks@vt.edu
Cc: Cliff Wickman <cpw@sgi.com>, linux-kernel@vger.kernel.org, mingo@elte.hu,
        hpa@zytor.com, tglx@linutronix.de, rja@americas.sgi.com
Subject: Re: [PATCH v3] x86: UV kdump reboot fix
Message-ID: <20110403000153.GC31742@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <E1Q5Iuo-00013b-UK@eag09.americas.sgi.com> <45253.1301777257@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45253.1301777257@localhost>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 02, 2011 at 04:47:37PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 31 Mar 2011 09:32:02 CDT, Cliff Wickman said:
> > From: Cliff Wickman <cpw@sgi.com>
> > 
> > After a crash dump on an SGI Altix UV system the crash kernel fails to
> > cause a reboot.  EFI mode is disabled in the kdump kernel, so only the
> > reboot_type of BOOT_ACPI works.
> 
> > +	/*
> > +	 * for a kdump kernel the reset must be BOOT_ACPI, not BOOT_EFI, as
> > +	 * EFI is not enabled in the kdump kernel.
> > +	 */
> > +	if (is_kdump_kernel())
> > +		reboot_type = BOOT_ACPI;
> >  }
> 
> What happens if some bozo builds their own kdump kernel that has EFI enabled?

kdump can use the same EFI enabled kernel currently running on the
system.  When kexec starts the kdump kernel it indicates that
EFI is not enabled so the kernel does not use EFI.  

So what would happen is the bozo built kdump kernel would
work just fine.

There are a lot of detailed discussions of EFI & kdump if you want 
to know the details.
http://lkml.org/lkml/2010/7/27/315

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
