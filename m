Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab1JSStg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 14:49:36 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62839 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab1JSStd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 14:49:33 -0400
Date: Wed, 19 Oct 2011 22:49:26 +0400
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
Message-ID: <20111019184926.GY14464@moon>
References: <20111014110416.552685686@openvz.org>
 <20111014110511.670174429@openvz.org>
 <20111014171033.GC4294@google.com>
 <20111014173304.GD4294@google.com>
 <4E9E9255.7090601@parallels.com>
 <20111019182228.GJ25124@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111019182228.GJ25124@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 11:22:28AM -0700, Tejun Heo wrote:
> Hello, Pavel.
> 
> On Wed, Oct 19, 2011 at 01:03:17PM +0400, Pavel Emelyanov wrote:
> > > I don't think this is a good idea.  We already have most of interface
> > > necessary for restoring task state and there's no need to put it into
> > > the kernel as one piece.  If there's something which can't be done
> > > from userland using existing interfaces, let's please discuss what
> > > they are and whether they can be resolved differently first.
> > 
> > The rest API we will require will look too special-purpose (like Cyrill
> > mentioned the ability to set the mm's fields such as start_code, etc).
> 
> I find that quite difficult to agree with.  We're talking about some
> minor additions to prctl against updating exec path to do something it
> was never designed to do + new binary format.
> 

Hi Tejun,

apart from controversy on elf'ish restore, I would like to know if there
a way to poke alien process memory with something faster than sizeof(long)
at once as ptrace proposes. At moment on my test tasks it's not that long
but the problem is there are servers with GBs of memory and snapshotting
memory data becomes a bottleneck. The same applies to restore procedure,
especially on big-data-chunks. Hm? Am I missing something obvious?

	Cyrill
