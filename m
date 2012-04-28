Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab2D1Fgm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 01:36:42 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:44548 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366Ab2D1Fgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 01:36:37 -0400
Date: Sat, 28 Apr 2012 08:36:33 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Myron Stowe <mstowe@redhat.com>
cc: Bjorn Helgaas <bhelgaas@google.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: x86: runtime waring in pcibios_fwaddrmap_lookup
In-Reply-To: <1335557685.2386.62.camel@zim.stowe>
Message-ID: <alpine.SOC.1.00.1204280819270.14507@math.ut.ee>
References: <alpine.SOC.1.00.1204122238400.16365@math.ut.ee>  <CAErSpo6YnzywdjTTVdVEHj_E-B0ARBpZ+fiy29Rv==fO6m9-FA@mail.gmail.com> <1335557685.2386.62.camel@zim.stowe>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So, somehow, your system hit the assertion (WARN_ON) in
> pcibios_fwaddrmap_lookup().  From the dmesg log you provided I can see
> why pcibios_save_fw_addr() was called - there is a resource collision
> with the video device's GART - but what I don't understand is how the
> assertion is being triggered.
> 
> There are only two callers of pcibios_fwaddrmap_lookup()
> (see ./arch/x86/pci/i386.c:: pcibios_save_fw_addr(), and
> pcibios_retrieve_fw_addr()) and both of those are acquiring the lock
> before making the call - so triggering the assertion just doesn't seem
> possible but obviously it is getting triggered.
> 
> I don't have any ideas currently but do have some questions that
> hopefully will start to enlighten us.
> 
>         Does your system encounter this consistently upon every boot or
>         is it hit intermittently?

Every time.

>         Do you know of any kernel versions that do not encounter it?

Checked my logs, no kernel up to 3.3.0 included gave it, next tested 
kernel was 3.4.0-rc2 and that had the warning and every kernel since has 
had it.

>         Are you running a para-virtualized kernel?

No.

-- 
Meelis Roos (mroos@ut.ee)      http://www.cs.ut.ee/~mroos/
