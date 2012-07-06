Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780Ab2GFJZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 05:25:52 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:59460 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271Ab2GFJZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 05:25:50 -0400
X-Greylist: delayed 311 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Jul 2012 05:25:50 EDT
Date: Fri, 6 Jul 2012 10:41:20 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: Olaf Hering <olaf@aepfle.de>
Cc: kexec@lists.infradead.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: incorrect layout of globals from head_64.S during kexec boot
Message-ID: <20120706084120.GA31219@router-fw-old.local.net-space.pl>
References: <20120705210607.GA26908@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120705210607.GA26908@aepfle.de>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 11:06:07PM +0200, Olaf Hering wrote:
>
> During kexec in a Xen PVonHVM guest the new kernel crashes most of the
> time in secondary_startup_64 because the content of phys_base is
> corrupted. Its not zero as expected but has some random other values.
> While debugging that crash I came up with the change below to inspect
> the memory around phys_base.
>
> It turned out that the globales are not in the expected memory location.
> An expected value such as phys_base_plus1 is shifted, but by a different
> amount during repeated kexec attempts. Up to now I havent figured out
> where this happens.
>
> My question is: were to put additional debug to trace the copying of the
> data section to its final destination? Is this a task of kexec -l or
> does that happen during decompressing? I suspect the latter. This is the
> console output before the crash (the crash happens in 'movq %rax, %cr3'):

Copy is done a few times durnig kexec/kdump but the most important
in this case, I think, is in relocate_kernel() function (look for
rep movsl or rep movsq and code around it). But I am a bit surprised
that kernel is decompressing itself. I always thought that it is done
during kexec/kdump load phase but maybe I am wrong. Could you send
me more info about your Linux Kernel version, kexec-tools version
and exact commands which you are using to load/exececute kernel?

Daniel
