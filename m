Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab0EEUDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 16:03:12 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57694 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab0EEUDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 16:03:10 -0400
Date: Wed, 5 May 2010 21:02:43 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Arve Hj?nnev?g <arve@android.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>, rebecca@android.com
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100505200243.GA6266@srcf.ucam.org>
References: <20100505185225.GA4411@srcf.ucam.org> <Pine.LNX.4.44L0.1005051511040.1885-100000@iolanthe.rowland.org> <20100505192208.GB5085@srcf.ucam.org> <20100505195249.GC11441@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100505195249.GC11441@sirena.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 08:52:50PM +0100, Mark Brown wrote:
> On Wed, May 05, 2010 at 08:22:08PM +0100, Matthew Garrett wrote:
> > Perhaps you could infer that from the audio routing setup? I don't know 
> > enough about embedded codecs.
> 
> Yes, you can providing we extract a bit more information from the
> machine drivers and/or userspace - we already do our power management
> based on paths.  The implementation I'd do here is to provide a facility
> for marking some of the path endpoints as suspend insensitive then on
> suspend leave those endpoints in their current state, force the other
> endpoints off temporarily and re-run the standard power checks.

One thing that's been mentioned before is that some vendors can swap the 
kernel much more easily than they can swap userspace, with the added 
constraint that they have little control over the bootloader. So if 
there's a userspace interface, it may well also be helpful to provide a 
kernel hook to allow the platform setup code to configure things. But 
otherwise, I think that'd work for audio - the only question is whether 
we need it to be more generic.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
