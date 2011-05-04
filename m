Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab1EDT05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 15:26:57 -0400
Received: from adelie.canonical.com ([91.189.90.139]:44511 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab1EDT0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 15:26:55 -0400
Date: Wed, 4 May 2011 14:26:39 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org,
        ath5k-devel@venema.h4ckr.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: ath5k regression associating with APs in 2.6.38
Message-ID: <20110504192639.GB4551@thinkpad-t410>
Mail-Followup-To: "John W. Linville" <linville@tuxdriver.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org,
	ath5k-devel@venema.h4ckr.net, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20110504153819.GA4551@thinkpad-t410>
 <20110504172716.GC18541@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504172716.GC18541@tuxdriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 01:27:17PM -0400, John W. Linville wrote:
> On Wed, May 04, 2011 at 10:38:19AM -0500, Seth Forshee wrote:
> > I've been investigating some reports of a regression in associating with
> > APs with AR2413 in 2.6.38. Association repeatedly fails with some
> > "direct probe to x timed out" messages (see syslog excerpt below),
> > although it will generally associate eventually, after many tries.
> > 
> > Bisection identifies 8aec7af (ath5k: Support synth-only channel change
> > for AR2413/AR5413) as offending commit. Prior to this commit there are
> > no direct probe messages at all in the logs. I've also found that
> > forcing fast to false at the top of ath5k_hw_reset() fixes the issue.
> > I'm not sure what the connection is between this commit and the
> > timeouts. Any suggestions?
> 
> Have you tried reverting that commit on top of 2.6.38?  Can you
> recreate the issue with 2.6.39-rc6 (or later)?

I started to revert that commit, but it wasn't straight-forward due to
later changes. Forcing fast to false in ath5k_hw_reset() acts as a
functional revert of sorts since that should force it back to a full
reset for all channel changes, and it's much simpler than working out
the right way to revert the commit. I think the results suggest strongly
that a revert is likely to fix the problem. I can finish the work to
revert if you'd still like to see the results.

Testing a previous .39-rc kernel still exhibited the failure. I don't
recall which one it was and apparently forgot to make note of it. I'll
request testing against rc6.

Thanks,
Seth
