Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab1HaOEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 10:04:20 -0400
Received: from shutemov.name ([188.40.19.243]:37210 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792Ab1HaOER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 10:04:17 -0400
Date: Wed, 31 Aug 2011 17:04:16 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>, containers@lists.osdl.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nathan Lynch <ntl@pobox.com>, Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Glauber Costa <glommer@parallels.com>,
        James Bottomley <jbottomley@parallels.com>, Tejun Heo <tj@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [patch 2/2] fs, proc: Introduce the /proc/<pid>/map_files/
 directory v6
Message-ID: <20110831140416.GA17626@shutemov.name>
References: <20110831075814.003575573@openvz.org>
 <20110831080229.100652529@openvz.org>
 <20110831090612.GA3253@albatros>
 <20110831112642.GI25465@sun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110831112642.GI25465@sun>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 03:26:42PM +0400, Cyrill Gorcunov wrote:
> On Wed, Aug 31, 2011 at 01:06:12PM +0400, Vasiliy Kulikov wrote:
> > Hi,
> > 
> > On Wed, Aug 31, 2011 at 11:58 +0400, Cyrill Gorcunov wrote:
> > > From: Pavel Emelyanov <xemul@parallels.com>
> > > 
> > > This one behaves similarly to the /proc/<pid>/fd/ one - it contains symlinks
> > > one for each mapping with file, the name of a symlink is "vma->vm_start-vma->vm_end",
> > > the target is the file. Opening a symlink results in a file that point exactly
> > > to the same inode as them vma's one.
> > 
> > I'm late noting it before the RFCv6 :)  Besides checking
> > ptrace_may_access() on ->lookup and ->readdir you also should define
> > ->stat, otherwise you can bypass ptrace checks if there is a
> > corresponding dentry in the cache.  The same issue existed in fd* handlers:
> > 
> > http://www.openwall.com/lists/kernel-hardening/2011/08/29/1
> > 
> 
> OK, here is an updated one. Thanks for feedback. Hope this time
> all nits are addressed. Still reviews/complains are *very* appreciated.

Please run checkpatch. It points several warnings and one dangerous error.

-- 
 Kirill A. Shutemov
