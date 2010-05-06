Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab0EFAui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 20:50:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49007 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559Ab0EFAug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 20:50:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Date: Thu, 6 May 2010 02:51:18 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: tytso@mit.edu, Matthew Garrett <mjg@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Brian Swetland <swetland@google.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       "Arve Hj?nnev?g" <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Paul Walmsley <paul@pwsan.com>, magnus.damm@gmail.com,
       mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>, rebecca@android.com
References: <20100505185225.GA4411@srcf.ucam.org> <201005060133.59417.rjw@sisk.pl> <20100506002125.GA22013@sirena.org.uk>
In-Reply-To: <20100506002125.GA22013@sirena.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005060251.18656.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 May 2010, Mark Brown wrote:
> On Thu, May 06, 2010 at 01:33:59AM +0200, Rafael J. Wysocki wrote:
> 
> > set up that way).  Even without the patchset you may implement a power
> > manager in user space that will suspend the system whenever it thinks it's
> > idle.
> 
> Clearly, but...
> 
> > On Thursday 06 May 2010, Mark Brown wrote:
> 
> > > In the primary existing application this change interoperates very poorly
> > > with at least the current audio subsystem since that handles suspend by
> > > ceasing all activity and powering as much as it can off, which is sensible for
> > > manual only suspends but highly undesirable for opportunistic suspend in
> > > phones.
> 
> > You said that there's no fundamental difference between manual and
> > opportunistic suspend.  It only matters what _you_ are going to use suspend
> > for.  I agree that at the moment it's not suitable for aggressive power
> > management in phones because of the audio problem, but that applies to
> > "manual" as well as to "opportunistic" suspend.
> 
> ...on the other hand there's exactly one existing application for this,
> and that's the one that's most likely to run into problems since it's a
> phone OS and aggressive power management is pretty important for phones.
> 
> Merging a feature into mainline makes it much more something which one
> would expect to play nicely with the rest of the kernel - if it's
> something that isn't part of the standard kernel or userspaces it's much
> less surprising that additional changes may be required to produce a
> well integrated system.
> 
> > You're saying that suspend is not suitable for one particular purpose in its
> > current form, which is entirely correct, but that doesn't imply that the
> > patchset is wrong.
> 
> As I keep saying I agree that merging this is reasonable given the
> additional power savings it brings in practical systems today.  As I
> also keep saying I do want to have some understanding about what the
> story is for dealing with the problems so that people can easily use
> this feature out of the box.
> 
> Like I say, my current impression is that the best approach is for
> affected subsystems or drivers to implement a custom solution - does
> that match your understanding and that of the other PM maintainers?

I agree that this appears to be the best approach for the time being, although
I can only speak for myself.

Rafael
