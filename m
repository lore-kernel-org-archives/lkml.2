Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625Ab0EEUPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 16:15:45 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33069 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab0EEUPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 16:15:42 -0400
Date: Wed, 5 May 2010 21:15:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Garrett <mjg@redhat.com>, Brian Swetland <swetland@google.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Arve Hj?nnev?g <arve@android.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100505201536.GE11441@sirena.org.uk>
References: <20100505192811.GA5468@srcf.ucam.org> <Pine.LNX.4.44L0.1005051554490.1885-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1005051554490.1885-100000@iolanthe.rowland.org>
X-Cookie: Do not overtax your powers.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 04:04:00PM -0400, Alan Stern wrote:

> P.S.: What happens if a suspend occurs while a call is in progress, so
> the codec is left powered up, and then the call ends?  Does the system
> wake up at that point?  Or does it stay suspended with the codec still
> powered, even though it's not needed any more?

Call end will be a system wake event in pretty much all systems,
userspace will want to do some work when the call goes away anyway.
Anyone who doesn't do that will see the CODEC stay powered, hopefully
the baseband will send it a nice mute signal instead of popping.
