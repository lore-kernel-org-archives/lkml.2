Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab0ELLWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 07:22:36 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56312 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab0ELLWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 07:22:34 -0400
Date: Wed, 12 May 2010 12:22:28 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arve Hj?nnev?g <arve@android.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100512112227.GA4312@sirena.org.uk>
References: <1272667021-21312-1-git-send-email-arve@android.com> <87wrvl5479.fsf@deeprootsystems.com> <87632vhbs8.fsf@deeprootsystems.com> <AANLkTikJV-wQX9xh8mRVptebJBctcRrQaUls-IGDhQar@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikJV-wQX9xh8mRVptebJBctcRrQaUls-IGDhQar@mail.gmail.com>
X-Cookie: Used staples are good with SOY SAUCE!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 06:11:09PM -0700, Arve Hj?nnev?g wrote:

> > 2.2 Usage in PM aware drivers
> > ==============================

> > [An example of how a driver already using runtime PM would use
> > ?a suspend blocker would also be helpful.

> An audio driver can block suspend while audio is playing. We don't
> currently use the runtime pm framework since this is new, but we do
> runtime pm by turning off clocks and power when the device is
> inactive.

Could you clarify what's going on here please?  What do you mean by an
"audio driver" here - there's several different classes of driver which
work together to produce the embedded audio subsystem and I'm not clear
which you're referring to here.  I'd not expect a chip-specific audio
driver to be taking suspend blockers at all except during things like
accessory detect handling which can take a long time.  A system-specific
driver could reasonably block during playback but doing it in a chip
specific driver sounds like a bit too much of a policy decision.

The kernel runtime PM framwwork tends not to come into play for anything
except MFD and SoC drivers with audio where they're a component of PM on
the larger chip and it's useful for coordinating with the other drivers
in play.  Otherwise we already have very detailed automatic power
management (especially for the CODECs) and there's no benefit in
bouncing through runtime PM.
