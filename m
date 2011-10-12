Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab1JLQfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 12:35:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37717 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399Ab1JLQfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 12:35:47 -0400
Date: Wed, 12 Oct 2011 18:33:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Don Zickus <dzickus@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>, seiji.aguchi@hds.com,
        vgoyal@redhat.com, mjg@redhat.com, tony.luck@intel.com,
        gong.chen@intel.com, satoru.moriya@hds.com, avi@redhat.com
Subject: Re: [PATCH 1/3] x86, reboot:  Use NMI instead of REBOOT_VECTOR to
 stop cpus
Message-ID: <20111012163358.GD31857@elte.hu>
References: <1318346686-12349-1-git-send-email-dzickus@redhat.com>
 <1318346686-12349-2-git-send-email-dzickus@redhat.com>
 <20111012073025.GI18618@elte.hu>
 <20111012125442.GJ5795@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111012125442.GJ5795@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> On Wed, Oct 12, 2011 at 09:30:25AM +0200, Ingo Molnar wrote:
> > 
> > * Don Zickus <dzickus@redhat.com> wrote:
> > 
> > > +		if (register_nmi_handler(NMI_LOCAL, smp_stop_nmi_callback,
> > > +					 NMI_FLAG_FIRST, "smp_stop"))
> > > +			return;		/* return what? */
> > 
> > That comment looks a bit odd.
> 
> Yeah, I copied it from the kdump code because it seemed relevant.  
> The point was to express the paranoid concern, if we can't register 
> the NMI handler for whatever reason, what happens!?.  How do we 
> explain to anyone we failed to shut down the other cpus?
> 
> I can expand the comment to be more specific in the paranoia.  I 
> just wasn't sure the right way to handle that failure case.

Just add something like:

	/* Note: we ignore failures here */

if there's nothing intelligent possible.

Thanks,

	Ingo
