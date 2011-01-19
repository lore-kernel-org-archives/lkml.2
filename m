Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab1ASQTB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 11:19:01 -0500
Received: from mail.openrapids.net ([64.15.138.104]:57233 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754412Ab1ASQS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 11:18:59 -0500
Date: Wed, 19 Jan 2011 11:18:57 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: David Miller <davem@davemloft.net>, rostedt@goodmis.org,
        richm@oldelvet.org.uk, 609371@bugs.debian.org, ben@decadent.org.uk,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@redhat.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
	Unknown relocation: 36
Message-ID: <20110119161857.GC15031@Krystal>
References: <20110118201323.GA14930@Krystal> <1295382144.12215.123.camel@gandalf.stny.rr.com> <20110119050844.GA8776@Krystal> <20110118.211639.68142725.davem@davemloft.net> <20110119151004.GA11022@Krystal> <20110119161455.GA18503@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110119161455.GA18503@merkur.ravnborg.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 11:15:52 up 56 days, 21:18,  5 users,  load average: 0.23, 0.05,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sam Ravnborg (sam@ravnborg.org) wrote:
> > 
> > If my memory serves me correctly, I think "long long" is aligned on 4 bytes on
> > ppc32, but on 8 bytes on x86_32 (yeah, that's weird). How about we create a
> > #define __long_long_aligned __attribute__((__aligned__(__alignof__(long long))))
> 
> #define __u64_aligned __attribute__((__aligned__(__alignof__(long long))))
> 
> A bit shorter but maybe less obvious.

Yep, that would make sense.

I'm tempted to try creating

#defined __u64_packed_aligned __attribute__((__packed__, __aligned__(__alignof__(long long))))

in the hope that gcc sees this as a strict alignment requirement (including a
max bound) rather than just a hint. From what I gather in my reading of 

http://gcc.gnu.org/onlinedocs/gcc/Type-Attributes.html

"The aligned attribute can only increase the alignment; but you can decrease it
by specifying packed as well. See below."

gcc seems to support having both specified. I think this would provide the kind
of alignment guarantees we really need here: both specifying the minimum _and_
maximum alignment.

Thoughts ?

Mathieu

> 
> 	Sam

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
