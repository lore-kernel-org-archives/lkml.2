Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759186Ab1EMNAh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 09:00:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44150 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758529Ab1EMNAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 09:00:35 -0400
Date: Fri, 13 May 2011 15:00:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Don Zickus <dzickus@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Andi Kleen <ak@linux.intel.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [RFC] x86, NMI, Treat unknown NMI as hardware error
Message-ID: <20110513130011.GA6474@elte.hu>
References: <1305275018-20596-1-git-send-email-ying.huang@intel.com>
 <20110513124523.GM13984@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110513124523.GM13984@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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

> On Fri, May 13, 2011 at 04:23:38PM +0800, Huang Ying wrote:
> > In general, unknown NMI is used by hardware and firmware to notify
> > fatal hardware errors to OS. So the Linux should treat unknown NMI as
> > hardware error and go panic upon unknown NMI for better error
> > containment.
> 
> I have a couple of concerns about this patch.  One I don't think BIOSes
> are ready for this.  I have Intel Westmere boxes that say they have a
> valid HEST, GHES, and EINJ table, but when I inject an error there is no
> GHES record.  This leaves me with an unknown NMI and panic.  Yeah, it is a
> BIOS bug I guess, but I think vendors are going to be slow fixing all this
> stuff (my Nehalem box is in even worse shape with this stuff).

Agreed, doing this is not a very good idea - we have spurious unknown NMIs 
again and again, crashing the box is not a good idea.

What should be done instead is to add an event for unknown NMIs, which can then 
be processed by the RAS daemon to implement policy.

By using 'active' event filters it could even be set on a system to panic the 
box by default.

Thanks,

	Ingo
