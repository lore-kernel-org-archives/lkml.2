Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933783Ab1CXIvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 04:51:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36493 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932655Ab1CXIvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 04:51:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Iq7sOHulkF0jnvIRUIzEppu7AgG8xWKs1TggASzkQYwXnOg4TnCIgzVO7w0JOQwRL9
         LWNjYDBwzylUi9UT+LtDmd31aIVWbecOUKq3Xa9c58JpAPZiaAgsIIvnVts4SettjaBB
         gDOBdDhsA5WPdFn0VNd61cnmBVPIhYB6Yep1c=
Date: Thu, 24 Mar 2011 09:51:12 +0100
From: Tejun Heo <tj@kernel.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: torvalds@osdl.org, Alexander van Heukelum <heukelum@fastmail.fm>,
        linux-am33-list@redhat.com,
        user-mode-linux-devel@lists.sourceforge.net,
        Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Mark Salter <msalter@redhat.com>,
        uclinux-dist-devel@blackfin.uclinux.org, akpm@linux-foundation.org,
        Ingo Molnar <mingo@elte.hu>,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Subject: Re: [Uclinux-dist-devel] [RFC PATCH] percpu: always align percpu
 output section to PAGE_SIZE
Message-ID: <20110324085112.GB12038@htj.dyndns.org>
References: <4CC69B22.2050708@kernel.org>
 <20101025224111.7798.38960.stgit@warthog.procyon.org.uk>
 <12101.1288088542@redhat.com>
 <4CC6C62F.1000804@kernel.org>
 <4CC6C941.2080003@kernel.org>
 <4CC6CD4D.3010501@kernel.org>
 <4CC6E05A.8040508@kernel.org>
 <AANLkTi=WWCPJeQ8DVv1j7GF0J61DiUupiOEuxDCW8_Xd@mail.gmail.com>
 <20110324082523.GA12038@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110324082523.GA12038@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 09:25:23AM +0100, Tejun Heo wrote:
> Hello,
> 
> On Thu, Mar 24, 2011 at 02:46:01AM -0400, Mike Frysinger wrote:
> > On Tue, Oct 26, 2010 at 10:06, Tejun Heo wrote:
> > > The linker script macros PERCPU_VADDR() and PERCPU() are used to
> > > define this output section and the latter takes @align parameter.
> > > Several architectures are using @align smaller than PAGE_SIZE breaking
> > > percpu memory alignment.
> > 
> > hmm, i just pushed through a fix in the Blackfin tree as we hit a boot
> > failure otherwise:
> > -   PERCPU(4)
> > +   PERCPU(PAGE_SIZE)
> > 
> > > This patch removes @align parameter from PERCPU(), renames it to
> > > PERCPU_SECTION and makes it always align to PAGE_SIZE.  While at it,
> > > add PCPU_SETUP_BUG_ON() checks such that alignment problems are
> > > reliably detected and remove percpu alignment comment recently added
> > > in workqueue.c as the condition would trigger BUG way before reaching
> > > there.
> > 
> > seems this still hasnt made it to mainline.  has it stalled or
> > something ?  feel free for the Blackfin bits:
> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> 
> Heh, I just forgot.  I'll queue it with your Acked-by added.

BTW, you're gonna push out the blackfin change to mainline soon,
right?  I'll queue the patch for the next merge window once the
blackfin fix hits mainline.

Thanks.

-- 
tejun
