Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab1JSSxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 14:53:48 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39309 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab1JSSxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 14:53:45 -0400
Date: Wed, 19 Oct 2011 11:53:40 -0700
From: Tejun Heo <tj@kernel.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
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
Message-ID: <20111019185340.GM25124@google.com>
References: <20111014110416.552685686@openvz.org>
 <20111014110511.670174429@openvz.org>
 <20111014171033.GC4294@google.com>
 <20111014173304.GD4294@google.com>
 <4E9E9255.7090601@parallels.com>
 <20111019182228.GJ25124@google.com>
 <20111019184926.GY14464@moon>
 <20111019185210.GZ14464@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111019185210.GZ14464@moon>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Oct 19, 2011 at 10:52:10PM +0400, Cyrill Gorcunov wrote:
> On Wed, Oct 19, 2011 at 10:49:26PM +0400, Cyrill Gorcunov wrote:
> ..
> > 
> > Hi Tejun,
> > 
> > apart from controversy on elf'ish restore, I would like to know if there
> > a way to poke alien process memory with something faster than sizeof(long)
> > at once as ptrace proposes. At moment on my test tasks it's not that long
> > but the problem is there are servers with GBs of memory and snapshotting
> > memory data becomes a bottleneck. The same applies to restore procedure,
> > especially on big-data-chunks. Hm? Am I missing something obvious?
> > 
> 
> Drop it, I had something different in mind, sorry for noise.

Heh, just in case.  Before resuming the restored process, the restorer
has full control.  Letting the target process reading and mmapping
itself should be enough, I think.

Thanks.

-- 
tejun
