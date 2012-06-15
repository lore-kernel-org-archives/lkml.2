Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792Ab2FOXhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 19:37:20 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43211 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758494Ab2FOXhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 19:37:17 -0400
Message-ID: <1339803436.26435.4.camel@joe2Laptop>
Subject: Re: [PATCH wireless-next 00/20] Use pr_<level>
From: Joe Perches <joe@perches.com>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, libertas-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 15 Jun 2012 16:37:16 -0700
In-Reply-To: <20120615225057.GD7363@thunk.org>
References: <cover.1339739415.git.joe@perches.com>
	 <1339745811.4512.0.camel@jlt3.sipsolutions.net>
	 <1339757319.24527.21.camel@joe2Laptop> <20120615225057.GD7363@thunk.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-15 at 18:50 -0400, Ted Ts'o wrote:
> On Fri, Jun 15, 2012 at 03:48:39AM -0700, Joe Perches wrote:
> > To tee up conversions of:
> > 	pr_<level>("%s: ...", ([truct netdevice *]foo)->name, ...)
> > to
> > 	netdev_<level>(foo, "...", ...) 
> 
> If the goal is to do the latter, why introduce needless patch churn
> now just to get to pr_<level>?  Having a standardized netdev_<label>()
> adds real benefit that can be weighed against the cost of code churn.
> Why not just wait until the netdev_<level> infrastructure can be
> introduced?  It will save effort on everybody's part.

Not really.  This standardizes prefixes as is.

The newlines and such will still occur.
The git blame noise etc too.

The standardization via spatch will be
significantly easier this way.  It's also
a far easier pattern to verify.

