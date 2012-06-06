Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab2FFBZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 21:25:10 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:36655 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab2FFBZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 21:25:08 -0400
Date: Wed, 6 Jun 2012 10:54:59 +0930
From: Christopher Yeoh <cyeoh@au1.ibm.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] CMA: Do no enable it by default
Message-ID: <20120606105459.49430920@Gantu>
In-Reply-To: <20120605110541.GC13495@aftab.osrc.amd.com>
References: <20120531153512.GK14515@aftab.osrc.amd.com>
	<20120531154224.GL14515@aftab.osrc.amd.com>
	<20120601110647.2c446aa7@rockpopper>
	<20120605110541.GC13495@aftab.osrc.amd.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12060515-9264-0000-0000-000001A694A1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2012 13:05:41 +0200
Borislav Petkov <bp@amd64.org> wrote:
> 
> CROSS_MEMORY_ATTACH is a MPI feature which shouldn't be enabled by
> default on every linux system simply because the majority of users do
> not need it.

btw although CMA was primarily written for MPI it is used by more than
just MPI implementations. For example, recent versions of strace now
use it instead of PTRACE_PEEKDATA if its available:

http://article.gmane.org/gmane.comp.sysutils.strace.devel/2467/match=process_vm_readv

> Besides, in the config option it says "... which allow a process with
> the correct privileges to directly read from or write to to another
> process's address space.", which, if the reading process has somehow
> gained privileges (as that never happens) is your security issue right
> there.

The privileges required are exactly the same as required to ptrace the
target. You're rather stuffed anyway if you have a hostile process with
those privileges.

Regards,

Chris
-- 
cyeoh@au.ibm.com

