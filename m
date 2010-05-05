Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab0EETIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 15:08:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60259 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750869Ab0EETIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 15:08:02 -0400
Date: Wed, 5 May 2010 20:07:58 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Garrett <mjg@redhat.com>, Brian Swetland <swetland@google.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Paul Walmsley <paul@pwsan.com>, magnus.damm@gmail.com,
       mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100505190758.GG7139@rakim.wolfsonmicro.main>
References: <20100505173337.GA1671@srcf.ucam.org>
 <Pine.LNX.4.44L0.1005051432120.1885-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1005051432120.1885-100000@iolanthe.rowland.org>
X-Cookie: Yow!  I threw up on my window!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 02:36:10PM -0400, Alan Stern wrote:

> Clearly if there's a call in progress you don't want to shut the codec
> down.  Are there any other circumstances?  Would they vary according to
> whether the suspend was forced or opportunistic?

Aside from things where the CODEC is acting as a wake source (for stuff
like jack detect) which are obviously already handled it's basically
just when you've got an external audio source flowing through the device
which is going to continue to function during suspend.  Things like FM
radios, for example.  I'm not aware of non-audio examples that are use
case specific and don't just involve utterly ignoring AP suspends.

> In short, I'm trying to get at how much information drivers _really_ 
> need to have about the reason for a system suspend.

It's not exactly the *reason* that makes the difference, it's more that
this aggressive use of suspend makes much more apparent a problem which
might exist anyway for this sort of hardware.

When we get runtime PM delviering similar power levels we'll sidestep
the problem since we won't need to do a system wide suspend.
