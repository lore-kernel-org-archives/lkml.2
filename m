Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab1DOQhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 12:37:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60680 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126Ab1DOQhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 12:37:52 -0400
Date: Fri, 15 Apr 2011 12:37:46 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: liubo <liubo2009@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Trace: add __print_symbolic_u64 to avoid warnings on
 32bit machine
Message-ID: <20110415163746.GA14185@infradead.org>
References: <4D9573DB.4010009@cn.fujitsu.com>
 <1301665762.2160.22.camel@gandalf.stny.rr.com>
 <4D9C2FF6.7090607@cn.fujitsu.com>
 <20110415092418.b18fd6fe.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110415092418.b18fd6fe.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 09:24:18AM -0700, Randy Dunlap wrote:
> Can this also be used to stop this warning that has been around
> like forever (on i386)?
> 
> linux-next-20110415/fs/xfs/linux-2.6/./xfs_trace.h:1354: warning: format '%llx' expects type 'long long unsigned int', but argument 22 has type 'xfs_fsblock_t'

What about reporting the bug?  And no, it won't help.  The only
thing that helps would be casting the argument to (long long).  If you
send me (and/or the xfs list) a list of the warnings you see I'm happy
to fix them, although I don't see them during my x86 builds.  Could it
be that you have CONFIG_LBD disabled?  That's surely not a popular
option with XFS users.

