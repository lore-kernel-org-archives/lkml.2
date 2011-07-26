Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab1GZWpN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 18:45:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60094 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753188Ab1GZWpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 18:45:09 -0400
Date: Tue, 26 Jul 2011 15:45:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oliver Neukum <oneukum@suse.de>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: better oopsing when frozen
Message-Id: <20110726154502.14c7b51b.akpm@linux-foundation.org>
In-Reply-To: <201107270024.11194.rjw@sisk.pl>
References: <201107251043.19932.oneukum@suse.de>
	<201107270024.11194.rjw@sisk.pl>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jul 2011 00:24:11 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> > Hi Rafael,
> > 
> > I had a problem with the kernel stopping the machine forever because I got an
> > oops while tasks were frozen. It seems to me that we should thaw when this
> > happens. How about this approach?
> 
> Well, we do something like this already for the OOM killer (see
> oom_killer_disable() and friends), so I think it would be better to
> simply extend/modify that mechanism instead of adding a new one
> doing almost exactly the same thing.
> 
> I have no complaints about adding thaw_in_oops(), though, so long as
> Andrew thinks it makes sense.

mm...  The patch as proposed is very simple, direct, explicit.  I
suspect that trying to embed this operation within some other one would
end up producing a less clear result.  Sometimes we do exceptional and
weird things, and leaving the code exceptional and weird-looking is
better than hiding it in some framework, if you follow what I mean.

It does need some code comments to explain to people what it's doing
and more importantly why it's doing it.  Also, something which doesn't
break the build when CONFIG_FREEZER=n would be nice.

