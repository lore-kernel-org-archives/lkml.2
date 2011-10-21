Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538Ab1JUSgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 14:36:36 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53117 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab1JUSgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 14:36:35 -0400
Date: Fri, 21 Oct 2011 22:36:28 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrey Vagin <avagin@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [patch 5/5] elf: Add support for loading ET_CKPT files
Message-ID: <20111021183628.GH31508@moon>
References: <20111014110416.552685686@openvz.org>
 <20111014110511.670174429@openvz.org>
 <20111014171033.GC4294@google.com>
 <20111014173304.GD4294@google.com>
 <4E9E9255.7090601@parallels.com>
 <20111019182228.GJ25124@google.com>
 <20111019195632.GB14464@moon>
 <20111021182610.GB28670@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111021182610.GB28670@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 11:26:10AM -0700, Tejun Heo wrote:
> Hello,
> 
> On Wed, Oct 19, 2011 at 11:56:32PM +0400, Cyrill Gorcunov wrote:
> > > I find that quite difficult to agree with.  We're talking about some
> > > minor additions to prctl against updating exec path to do something it
> > > was never designed to do + new binary format.
> > 
> > Tejun, regardless the mm_struct entries, what about mapping vdso pages at the
> > place they had on snapshot time? How would we handle them?
> 
> We discussed this elsewhere but just for the record.
> 

Yes ;)

> I haven't really looked into vdso but what the currently suggested
> implementation isn't correct.  vdso is there so that kernel can
> provide userspace code which may vary depending on kernel version and
> the actual machine it's running on, so both saving vdso and restoring
> verbatim and asking the kernel to map its vdso at certain address are
> wrong.
> 

It's fine for first iteration (or rather for first RFC where such details
exactly to be revealed and discussed).

> The checkpointer would need to remember the vdso symtab from the
> original process and then somehow build indirect jump table at the
> same address which redirects to the vdso of the machine the target
> process is being restored on.  I'm not sure about the details of the
> implementation but it could be something like "please allow me to
> write to this original vdso address and keep your vdso elsewhere".
> 

Original vdso address should remain as it was at checkpoint time but
you're right that we need kinda bridge between various kernels versions
I think.

> I think this comes back to why one-stop-solution-in-kernel is a bad
> idea for CR.  My impression is that when people say "that would
> require too many small API updatesa", it usually means that they
> haven't really thought about each necessary piece enough and just
> hacked something up lumpy and fuzzy on the edges.  The thing is that
> no matter how you lump them, those problems don't go away and
> attacking things in small understandable API pieces not only ensures
> the update itself makes sense and may be useful for others too but
> also forces people to actually think about each problem.
> 

	Cyrill
