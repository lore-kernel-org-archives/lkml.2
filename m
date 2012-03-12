Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894Ab2CLW4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 18:56:05 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64503 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757576Ab2CLW4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 18:56:02 -0400
Date: Mon, 12 Mar 2012 15:55:57 -0700
From: Tejun Heo <tj@kernel.org>
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Michal Schmidt <mschmidt@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        Lennart Poettering <lennart@poettering.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Message-ID: <20120312225557.GK23255@google.com>
References: <20120221211938.GE12236@google.com>
 <20120312221050.GG23255@google.com>
 <20120312223707.GA8272@peqn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120312223707.GA8272@peqn>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Mar 12, 2012 at 05:37:07PM -0500, Serge Hallyn wrote:
> Quoting Tejun Heo (tj@kernel.org):
> > Hello, guys.
> > 
> > Thanks a lot for the discussion and here are my take aways:
> > 
> > * At least to me, nobody seems to have strong enough justification for
> >   orthogonal multiple hierarchies, so, yeah, unless something else
> 
> First off, can you (sorry) show an example of exactly what would no
> longer be supported?  Is this the ability to not separately mount
> freezer and cpusets (for instance)?

I think there are two aspects of it - there's actual functionality
loss and there's loss of one of the ways to achieve something.

The former is applying completely orthogonal categorizations to
processes depending on the controller in use - ie. memory limits by
user and disk IO limits by the program binary.  AFAICS, nobody seems
to have strong enough justification for this.

The latter is probably more material.  Even when people aren't using
orthogonal categorizations, they probably are using separate
hierarchies - currently, it's almost unavoidable to do so.  So, that
part would be more painful.  What I hope for is that some userland
system management tooling takes ownership of the cgroup fs interface
to impose some sane hierarchy and defaults, and expose more policy
aware interface to the rest of the system.

> I've submitted a topic for the upcoming linux foundation end user summit
> in new york, to get feedback from end users.  (Frankly I don't want to go
> so would love if someone else wanted to do this :).  I think it'd be nice
> to wait and see if this gets accepted, and see whether any end users are
> relying on this.
> 
> (IMO it's wrong to say that "if you are using a current feature, you'd
> better be reading lkml so you can speak up lest that feature might get
> removed.")

Well, these mailing lists are the widest comm channel I can make use
of and I expect there to be people to chain and propagate the
communication to many different channels as necessary.  So, yes, it
would be very appreciated if you can bring up the topic with larger /
different crowd. :)

Thank you.

-- 
tejun
