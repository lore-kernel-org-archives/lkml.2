Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab2FFM7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 08:59:07 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:42352 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab2FFM7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 08:59:05 -0400
Date: Wed, 6 Jun 2012 14:59:29 +0200
From: Borislav Petkov <bp@amd64.org>
To: Christopher Yeoh <cyeoh@au1.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] CMA: Do no enable it by default
Message-ID: <20120606125929.GD1644@aftab.osrc.amd.com>
References: <20120531153512.GK14515@aftab.osrc.amd.com>
 <20120531154224.GL14515@aftab.osrc.amd.com>
 <20120601110647.2c446aa7@rockpopper>
 <20120605110541.GC13495@aftab.osrc.amd.com>
 <20120606105459.49430920@Gantu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120606105459.49430920@Gantu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 10:54:59AM +0930, Christopher Yeoh wrote:
> > CROSS_MEMORY_ATTACH is a MPI feature which shouldn't be enabled by
> > default on every linux system simply because the majority of users do
> > not need it.
> 
> btw although CMA was primarily written for MPI it is used by more than
> just MPI implementations. For example, recent versions of strace now
> use it instead of PTRACE_PEEKDATA if its available:
> 
> http://article.gmane.org/gmane.comp.sysutils.strace.devel/2467/match=process_vm_readv

I see.

Looks like process_vm_readv() is faster than PTRACE_PEEKDATA. You
could add this to the config option text so people can know why they
could/should enable CMA.

Oh, and also the note about ptrace privileges below :-).

> > Besides, in the config option it says "... which allow a process with
> > the correct privileges to directly read from or write to to another
> > process's address space.", which, if the reading process has somehow
> > gained privileges (as that never happens) is your security issue right
> > there.
> 
> The privileges required are exactly the same as required to ptrace the
> target. You're rather stuffed anyway if you have a hostile process with
> those privileges.

Ok.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
