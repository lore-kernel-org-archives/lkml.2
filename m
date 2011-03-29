Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab1C2N6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 09:58:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290Ab1C2N6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 09:58:43 -0400
Date: Tue, 29 Mar 2011 09:58:00 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: device-mapper development <dm-devel@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <jaxboe@fusionio.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <James.Bottomley@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Need to refactor DM's integrity profile support a bit (was: Re:
 Please revert a91a2785b20)
Message-ID: <20110329135800.GB23508@redhat.com>
References: <alpine.LFD.2.00.1103290006070.2774@localhost6.localdomain6>
 <alpine.LFD.2.00.1103290040300.2774@localhost6.localdomain6>
 <20110328230319.GA12790@redhat.com>
 <4D918347.7050500@fusionio.com>
 <20110329132032.GA22921@redhat.com>
 <yq1lizyhwlr.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1lizyhwlr.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29 2011 at  9:42am -0400,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Mike,
> 
> Mike> But I think we have a related issue that needs discussion, given
> Mike> that an integrity profile mismatch will cause MD's assemble to
> Mike> fail (rather than warn and continue to assemble without integrity
> Mike> support).
> 
> Mike> DM doesn't fail to load a DM device due to a integrity profile
> Mike> mismatch; it just emits a warning and continues.
> 
> Mike> In contrast, MD will now disallow adding a normal disk (without
> Mike> integrity support) to an array that has historically had a
> Mike> symmetric integrity profile across all members.
> 
> You would invalidate all your existing integrity metadata, tagging,
> etc. on existing metadevice members. That seems to be a policy decision,
> so if we go down that path it would have to be keyed off a force
> assembly option passed down from userland tooling. Turning off features
> and/or losing metadata really should not be done without the user's
> explicit consent.
> 
> Also, let's assume you run an integrity-aware app on a DM device and you
> add a non-integrity drive. The DM device is then no longer capable of
> carrying integrity metadata out to storage. What happens to the app?
> What about outstanding writes with metadata attached?
> 
> Good discussion topic for next week, methinks...

Sure, I'm just trying to reconcile the difference in behavior between MD
and DM.  Seems DM missed out on the integrity profile error propagation
treatment that MD just received.

Easily resolved (though there are some dragons lying in wait relative to
where this inconsistency is detected by DM, hint: must be during DM
table load).  Current hook, dm_table_set_integrity, disables the
integrity support of the DM device well beyond the point of no return
(when resuming a DM device that was allowed to have a new table loaded).

I welcome discussing this in a bit more detail in the hallway track at
LSF ;)

Thanks,
Mike
