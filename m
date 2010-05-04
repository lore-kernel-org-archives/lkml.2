Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933878Ab0EDUhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 16:37:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43146 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933738Ab0EDUhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 16:37:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Date: Tue, 4 May 2010 22:37:56 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       Brian Swetland <swetland@google.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
References: <1272667021-21312-1-git-send-email-arve@android.com> <87r5lrh780.fsf@deeprootsystems.com> <20100504190656.GA4611@opensource.wolfsonmicro.com>
In-Reply-To: <20100504190656.GA4611@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005042237.56844.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 May 2010, Mark Brown wrote:
> On Tue, May 04, 2010 at 11:06:39AM -0700, Kevin Hilman wrote:
> 
> > With opportunistic suspend, all of this flexibility is gone, and the
> > device/subsystem is told to go into the lowest power, highest latency
> > state, period.
> 
> Well, half the problem I have is that unfortunately it's not a case of
> doing that period.  The prime example I'm familiar with is that for
> understandable reasons users become irate when you power down the audio
> CODEC while they're in the middle of a call so if opportunistic PM is in
> use then the audio subsystem needs some additional help interpreting a
> suspend request so that it can figure out how to handle it.  Similar
> issues apply to PMICs, though less pressingly for various reasons.
> 
> Just to be clear, I do understand and mostly agree with the idea that
> opportunistic suspend presents a reasonable workaround for our current
> inability to deliver good power savings with runtime PM methods on many
> important platforms but I do think that if we're going to make this
> standard Linux PM functionality then we need to be clearer about how
> everything is intended to hang together.

At the moment the rule of thumb is: if you don't need the opportunistic
suspend, don't use it.  It is not going to be enabled by default on anything
other than Android right now.

However, since Android is a legitimate user of the Linux kernel, I see no
reason to reject this feature right away.  There are many kernel features
that aren't used by all platforms.

Rafael
