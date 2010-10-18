Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757800Ab0JRWAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 18:00:47 -0400
Received: from smtp-out.google.com ([74.125.121.35]:38878 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125Ab0JRWAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 18:00:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=kYBjPS2tFp3oKxcZX+OGXXZhpM/f9rzRswkvAM+Cm7NMAI4+aAGD9HtKUO98WR84cd
         wX9AU/bWXl5V++0/+uQg==
Date: Mon, 18 Oct 2010 15:00:36 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2] x86: Cleanup TIF value gaps in shift range
In-Reply-To: <4CBCBF9D.1060409@zytor.com>
Message-ID: <alpine.DEB.2.00.1010181451030.18444@chino.kir.corp.google.com>
References: <1287434158-24362-1-git-send-regression-fweisbec@gmail.com> <alpine.DEB.2.00.1010181340080.10965@chino.kir.corp.google.com> <alpine.LFD.2.00.1010182320440.6815@localhost6.localdomain6> <4CBCBBFC.1090500@zytor.com>
 <alpine.DEB.2.00.1010181431440.15782@chino.kir.corp.google.com> <4CBCBF9D.1060409@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010, H. Peter Anvin wrote:

> > It's not insane if there is no other way to ascertain that information.  
> > If it's available through sysfs or debugfs (and, even better, documented 
> > as part of the API in Documentation/ABI), then I don't think anyone would 
> > object to changing a log message.  But I don't think all log messages 
> > should be fair game under some general principle if they are being changed 
> > (instead of just extending it) without a compelling reason, such as 
> > technically being incorrect in its present form.
> 
> YES IT IS.  In fact, it is completely and totally bananas bonkers.
> 
> By not pushing for a proper maintainable ABI, you will have an
> indefinite forward compatibility problem, and when predictably it
> breaks, you'll complain.  This is, however, backwards -- the right thing
> would have been to say "I need this, this isn't available, I should add
> a maintainable API and push it upstream", and perhaps add log parsing as
> a backwards-compatibility solution.
> 

The problem is deciding what should be an ABI and what shouldn't an ABI 
when it isn't clear.  It would be great if everything that is logged or 
shown to userspace would be part of an ABI and would be available no 
matter how much information is emitted to the log.  That's not scalable, 
so we have to decide what userspace may depend on and design ABIs that 
provide that information in an extendable way that won't break or become 
obsoleted in the foreseeable future.

Since we can't do that for everything and we have no idea what users will 
find to parse from the dmesg, I'm advocating that if a change is proposed, 
like was in this case with ti->flags, and someone has a usecase where the 
information isn't available in any other way, that they speak up and come 
up with a maintainable solution so that we've identified the parties 
involved and can change that log message if necessary.  I only think that 
should be done, though, when there is a compelling reason for the change.

I think that was done in this case by suggesting an alternative (printing, 
at minimum, "M" when a thread has TIF_MEMDIE set instead of the raw flag 
bits), but I don't think the change itself was compelling enough that it 
has to be done.  That doesn't mean doing the change I suggested wasn't 
still appropriate, but at least it was known as a prerequisite before 
something like this should be merged.
