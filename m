Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab1I0R7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 13:59:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478Ab1I0R7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 13:59:36 -0400
Date: Tue, 27 Sep 2011 13:59:19 -0400
From: Don Zickus <dzickus@redhat.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>, Matthew Garrett <mjg@redhat.com>,
        "Chen, Gong" <gong.chen@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH -next] pstore: replace spin_lock with
 spin_trylock_irqsave in panic path
Message-ID: <20110927175919.GK5795@redhat.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C56C9B823@USINDEVS01.corp.hds.com>
 <20110927173413.GJ5795@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301EE4211E3@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301EE4211E3@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 10:46:32AM -0700, Luck, Tony wrote:
> > Personally, I am not sure we want to abort here at the pstore layer, it
> > should probably be aborted lower.  There isn't any reason why we can't
> > continue from a pstore perspective (we can just bust the spinlock).
> 
> But do we really have much chance at getting a real dump in this case?
> The pstore buf_lock is protecting the memory that the backend uses to
> save the data. If we can't get the lock, then we are going to conflict
> using that buffer with whoever does have the lock. So we will probably
> mess up whatever data they were trying to save, as well as not managing

Ok.  Do we care?  I assumed the panic data would be more
relevant/interesting than whatever pstore was doing before (like loading
previous log files).

> to save our panic data. So this isn't just a back-end issue, it is

I assumed we are just overwriting the buffer with the current data, so
unless the other cpu is chugging along while this cpu is in panic, the new
data shouldn't get corrupted, no?

Cheers,
Don

> fundamental to the pstore layer (since it depends on this back end buffer).
> 
> This is a tough call - but I'm leaning a bit towards taking this patch.
> 
> I agree with your suggestion that we need a better comment by the "return"
> (and also in the change log) saying why we are not saving the panic dmesg.
> 
> -Tony 
