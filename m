Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab2IUMRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 08:17:21 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:36973 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab2IUMRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 08:17:19 -0400
Date: Fri, 21 Sep 2012 06:17:18 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Guo Chao <yan@linux.vnet.ibm.com>
Cc: viro@zeniv.linux.org.uk, dchinner@redhat.com, hch@infradead.org,
        jack@suse.cz, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v4 Patch 0/4] fs/inode.c: optimization for inode lock
	usage
Message-ID: <20120921121717.GB24919@parisc-linux.org>
References: <1348219866-1799-1-git-send-email-yan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348219866-1799-1-git-send-email-yan@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 05:31:02PM +0800, Guo Chao wrote:
> This patchset optimizes several places which take the per inode spin lock.
> They have not been fully tested yet, thus they are marked as RFC. 
> 
> I do limited tests after all patches applied: use two 'find' to traverse the 
> filesystems and touch all files in parallel. This runs for several days in a 
> virtual machine, no suspicious log appears. 

Have you done any performance testing?  Taking and releasing a lock which
isn't contended is not particularly expensive.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
