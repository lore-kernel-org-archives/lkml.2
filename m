Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab0EEXdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 19:33:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48812 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576Ab0EEXdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 19:33:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Date: Thu, 6 May 2010 01:33:59 +0200
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
References: <20100505185225.GA4411@srcf.ucam.org> <201005060005.01215.rjw@sisk.pl> <20100505230917.GA5269@opensource.wolfsonmicro.com>
In-Reply-To: <20100505230917.GA5269@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005060133.59417.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 May 2010, Mark Brown wrote:
> On Thu, May 06, 2010 at 12:05:01AM +0200, Rafael J. Wysocki wrote:
> 
> > So, gnerenally, we may need a mechanism to specify which components of the
> > system need to stay powered while the whole system is suspended (in addition to
> > wakeup devices, that is).
> 
> > That certainly I can agree with.
> 
> > I'm not sure, however, in what way this is relevant to the $subject patchset.
> 
> The patch set essentially makes using a full system suspend as the
> lowest power state for runtime PM part of the standard Linux power
> management toolkit which means that it's no longer clear as it used to
> be that suspend is an instruction to cease all activity and go into a
> minimal power state if the device is not a wake source.

I don't see why, really.  This patchset doesn't change the meaning of suspend
at all, it only changes the way in which suspend is triggered (if specifically
set up that way).  Even without the patchset you may implement a power
manager in user space that will suspend the system whenever it thinks it's
idle.

> In the primary existing application this change interoperates very poorly
> with at least the current audio subsystem since that handles suspend by
> ceasing all activity and powering as much as it can off, which is sensible for
> manual only suspends but highly undesirable for opportunistic suspend in
> phones.

You said that there's no fundamental difference between manual and
opportunistic suspend.  It only matters what _you_ are going to use suspend
for.  I agree that at the moment it's not suitable for aggressive power
management in phones because of the audio problem, but that applies to
"manual" as well as to "opportunistic" suspend.

You're saying that suspend is not suitable for one particular purpose in its
current form, which is entirely correct, but that doesn't imply that the
patchset is wrong.

Rafael
