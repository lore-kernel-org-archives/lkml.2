Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab2E3Vgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 17:36:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46572 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812Ab2E3Vgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 17:36:47 -0400
Date: Wed, 30 May 2012 22:36:38 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Paris <eparis@parisplace.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@us.ibm.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix IMA lockdep circular locking dependency
Message-ID: <20120530213638.GZ11775@ZenIV.linux.org.uk>
References: <CA+55aFy0wJdq+-OAkUBsrkQogF5-N0P4DBQ+6-LXjBGscRQFNw@mail.gmail.com>
 <20120516021828.GP22082@ZenIV.linux.org.uk>
 <1337807899.15138.31.camel@falcor>
 <20120530043443.GA3200@ZenIV.linux.org.uk>
 <20120530163605.GV11775@ZenIV.linux.org.uk>
 <1338406967.2257.24.camel@localhost>
 <20120530202427.GW11775@ZenIV.linux.org.uk>
 <CA+55aFxiCksfNdRrm+O-eJSY=qTUQEsZtFbi8wj2_kj1XeNHnQ@mail.gmail.com>
 <20120530205612.GY11775@ZenIV.linux.org.uk>
 <CA+55aFwXfD6vCj8sHuB33ctB-D8cfJN45h+iURXA6mR=S0mgwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwXfD6vCj8sHuB33ctB-D8cfJN45h+iURXA6mR=S0mgwA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 02:04:23PM -0700, Linus Torvalds wrote:
> Generating 'prot' from 'reqprot' really *should* be as simple as what
> I did in my patch. The fact that some places f*ck it up is their
> problem - see for example mprotect (I think) that didn't take
> MNT_NOEXEC into account.
> 
> Don't try to emulate those broken semantics. Just fix them.

Actually, it's better than I thought, but not as simple as you say.
I've misread what's going on in !file case; mea culpa, they are
actually acting the same way there.

The only difference is that for file-backed ones !MMU wants
VM_MAYEXEC in that file's bdi flags (BDI_CAP_EXEC_MAP).  And
that actually sounds reasonable in !MMU case.

Anyway, I've dumped the variant I've got into vfs.git@security_file_mmap;
it should be at commit f12a0fd062b1d259a0b6bc6442019e6d4c45e9f5.

Comments?
