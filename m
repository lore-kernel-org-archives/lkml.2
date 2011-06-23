Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758989Ab1FWI6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 04:58:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60959 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667Ab1FWI6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 04:58:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZXpgNAE6woKCk/GkV9r288GlGJvKot5DcHn63JtySxUhXfp40a+TAf/Ht5iWJeSFEx
         804VgCOKuqh+IVNNV5qqtd3zhVtkIN1Niiw5FmH8Oic+t0fAlqYMm8URm6LA0gH8kOHZ
         xL2UdPsIos6q7kUb2iS/EFsqV2ML6iJHRWJn4=
Date: Thu, 23 Jun 2011 10:58:14 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, hch@infradead.org
Subject: Re: [PATCH 3/7] ptrace: move SIGTRAP on exec(2) logic to
 ptrace_event()
Message-ID: <20110623085814.GG30101@htj.dyndns.org>
References: <1308322240-8247-1-git-send-email-tj@kernel.org>
 <1308322240-8247-4-git-send-email-tj@kernel.org>
 <20110620202504.GB17157@redhat.com>
 <BANLkTimuRogA6St5GP0sRd1CY5u=jBABBg@mail.gmail.com>
 <20110621204001.GB6738@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110621204001.GB6738@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jun 21, 2011 at 10:40:01PM +0200, Oleg Nesterov wrote:
> > The intention is to concentrate ptrace specific logic in
> > ptrace_event().  We'll have more of them, mostly dependent on
> > PT_SEIZED and I don't think it's a good idea to scatter them across
> > the kernel.  They're of no interest outside of ptrace after all.  I
> > think it's better to have them collected in one place than scattered
> > around.
> 
> This was one of the reasons for tracehooks ;)

Yeah, sure.  The problem with tracehook is not that it's a
fundamentally wrong thing to do but it's way over done than actually
necessary and full of requirements which are of no interest to inside
the upstream kernel.

> OK, we can move this helper to ptrace.h although I do not think this
> makes sense. As for "scattered around", imho the code which calculates
> trace in do_fork() falls into the same category.
> 
> I still can't understand why ptrace_event() should check EVENT_EXEC.
> This is the special case, it should be handled specially. And while
> I think this is not that important, this is not friendly to do_fork,
> compiler has to generate the code to check event.

The generated code should be the same.  I didn't check all the cases
but the few I check didn't really change.

> But OK, I applied 1-5 and 7. This is minor, and we can reconsider this
> later. I mean, right now I think I'll send the cleanup later, and you
> will have to explain your nack ;)

Yeah, yeah, it's a minor point one way or the other.  I was (and still
is) thinking about folding most of ptrace-specific event logics into
ptrace_event() and this was just a first step as I think adding more
condition checks in fs/exec.c doesn't make much sense - ie. I might
end up adding PT_SEZIED there too.

Thanks.

-- 
tejun
