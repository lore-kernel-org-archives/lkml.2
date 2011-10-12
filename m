Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab1JLMzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 08:55:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528Ab1JLMzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 08:55:08 -0400
Date: Wed, 12 Oct 2011 08:54:42 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>, seiji.aguchi@hds.com,
        vgoyal@redhat.com, mjg@redhat.com, tony.luck@intel.com,
        gong.chen@intel.com, satoru.moriya@hds.com, avi@redhat.com
Subject: Re: [PATCH 1/3] x86, reboot:  Use NMI instead of REBOOT_VECTOR to
 stop cpus
Message-ID: <20111012125442.GJ5795@redhat.com>
References: <1318346686-12349-1-git-send-email-dzickus@redhat.com>
 <1318346686-12349-2-git-send-email-dzickus@redhat.com>
 <20111012073025.GI18618@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111012073025.GI18618@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 09:30:25AM +0200, Ingo Molnar wrote:
> 
> * Don Zickus <dzickus@redhat.com> wrote:
> 
> > +		if (register_nmi_handler(NMI_LOCAL, smp_stop_nmi_callback,
> > +					 NMI_FLAG_FIRST, "smp_stop"))
> > +			return;		/* return what? */
> 
> That comment looks a bit odd.

Yeah, I copied it from the kdump code because it seemed relevant.  The
point was to express the paranoid concern, if we can't register the NMI
handler for whatever reason, what happens!?.  How do we explain to anyone
we failed to shut down the other cpus?

I can expand the comment to be more specific in the paranoia.  I just
wasn't sure the right way to handle that failure case.

Thanks for your comments in the other patches, I'll work on those.

Cheers,
Don
