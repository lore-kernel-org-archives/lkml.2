Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab0G0FCM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 01:02:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650Ab0G0FCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 01:02:10 -0400
Date: Tue, 27 Jul 2010 07:55:34 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Sridhar Samudrala <sri@us.ibm.com>, Peter Zijlstra <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        netdev <netdev@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitri Vorobiev <dmitri.vorobiev@movial.com>,
        Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH repost] sched: export sched_set/getaffinity to modules
Message-ID: <20100727045534.GA4316@redhat.com>
References: <4C2CA5C5.4040402@kernel.org>
 <20100701144624.GA11171@redhat.com>
 <4C2CABF2.2020801@kernel.org>
 <1277996135.1917.198.camel@laptop>
 <4C2E2987.9040702@us.ibm.com>
 <1278094270.1917.288.camel@laptop>
 <20100702210637.GA12433@redhat.com>
 <20100726171230.GA27644@redhat.com>
 <1280166688.3375.5.camel@localhost>
 <20100726180834.GA26988@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100726180834.GA26988@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 08:08:34PM +0200, Oleg Nesterov wrote:
> On 07/26, Sridhar Samudrala wrote:
> >
> > I have been testing out a similar patch that uses kernel_thread() without CLONE_FILES
> > flag rather than create_kthread() and then closing the files.
> 
> !CLONE_FILES can't help. copy_files() does dup_fd() in this case.
> The child still inherits the files.
> 
> > Either version should be fine.
> 
> I think neither version is fine ;)
> 
> exit_files() is not enough too. How about the signals, reparenting?
> 
> 
> I already forgot all details, probably I missed somethig. But it
> seems to me that it is better to just export get/set affinity and
> forget about all complications.
> 
> Oleg.


Peter, could you please indicate whether you think this is the way to
go, too?

-- 
MST
