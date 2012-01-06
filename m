Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176Ab2AFLIt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 06:08:49 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46927 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933119Ab2AFLIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 06:08:48 -0500
Date: Fri, 6 Jan 2012 12:08:45 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86-64: memset()/memcpy() not fully standards compliant
Message-ID: <20120106110845.GW11715@one.firstfloor.org>
References: <4F05BBFE020000780006A983@nat28.tlf.novell.com> <20120105182846.GQ11715@one.firstfloor.org> <4F0630CC.7050001@zytor.com> <20120106014748.GS11715@one.firstfloor.org> <4F06566B.8080708@zytor.com> <20120106094922.GU11715@one.firstfloor.org> <4F06D979020000780006AC49@nat.nue.novell.com> <20120106103734.GV11715@one.firstfloor.org> <4F06DFEF020000780006AC84@nat28.tlf.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F06DFEF020000780006AC84@nat28.tlf.novell.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's not the traditional bootmem implementation anymore, but
> alloc_bootmem() et al still exist, and still clear the allocated memory
> (in __alloc_memory_core_early()). So there is a code path that can
> validly be used (and it is this code path that is presenting one of the
> problems with the non-pv-ops Xen kernels, as they're using flatmem
> rather than sparsemem since their physical address space is always
> fully continuous).

Yes but there should be no callers that do alloc_bootmem(4G)
The biggest ones afak are the 1GB pages I added some time ago.

How is it a problem in the non pv Xen kernels?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
