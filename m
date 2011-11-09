Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933443Ab1KIAH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 19:07:59 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:44023 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932781Ab1KIAHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 19:07:55 -0500
X-Sasl-enc: udD3V60ZiIAq5WBAFiJoLbk2DlrL4E1ML5bqblebhCw1 1320797274
Date: Tue, 8 Nov 2011 16:07:10 -0800
From: Greg KH <greg@kroah.com>
To: Clark Williams <williams@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "Ted Ts'o" <tytso@mit.edu>
Subject: Re: [ANNOUNCE] 3.0.8-rt22
Message-ID: <20111109000710.GC25933@kroah.com>
References: <alpine.LFD.2.02.1111072225340.2694@ionos>
 <20111108105019.794045fa@redhat.com>
 <alpine.LFD.2.02.1111082150490.2694@ionos>
 <20111108174452.497da95f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111108174452.497da95f@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 05:44:52PM -0600, Clark Williams wrote:
> On Tue, 8 Nov 2011 22:02:32 +0100 (CET)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Tue, 8 Nov 2011, Clark Williams wrote:
> > > Got the following splat on boot (f15 64-bit laptop, quad-core i7):
> > > 
> > > [  146.609030] 
> > > [  146.609031] =======================================================
> > > [  146.609033] [ INFO: possible circular locking dependency detected ]
> > > [  146.609035] 3.0.8-rt22+ #27
> > > [  146.609036] -------------------------------------------------------
> > > [  146.609038] dconf-service/9046 is trying to acquire lock:
> > > [  146.609040]  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff811adcc4>] ext4_evict_inode+0x44/0x26f
> > > [  146.609047] 
> > > [  146.609048] but task is already holding lock:
> > > [  146.609049]  (&mm->mmap_sem){++++++}, at: [<ffffffff81108ee6>] sys_munmap+0x36/0x5b
> > > [  146.609053] 
> > 
> > That's an upstream problem which got pulled into 3.0 stable via commit
> > 2526f36894 (upstream 2581fdc810) but lacks the followup upstream fix
> >  .  The latter unfortunately has no Cc: stable tag ....
> > 
> > Ted?
> > 
> > Thanks,
> > 
> > 	tglx
> 
> 
> Thanks Thomas. I cherry-picked 8c0bec2, rebuilt with the same config
> and have booted the resulting kernel with no lockdep splats.

Great, I've queued it up for the next 3.0-stable release.

greg k-h
