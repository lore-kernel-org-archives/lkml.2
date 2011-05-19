Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933660Ab1ESRPE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 13:15:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756881Ab1ESRPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 13:15:02 -0400
Subject: Re: [PATCH] Add libertas_disablemesh module parameter to disable
 mesh interface
From: Dan Williams <dcbw@redhat.com>
To: Sascha Silbe <silbe@activitycentral.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        devel <devel@lists.laptop.org>, John@xo15-sascha.sascha.silbe.org,
        W.Linville@xo15-sascha.sascha.silbe.org, linville@tuxdriver.com,
        libertas-dev <libertas-dev@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 19 May 2011 12:16:58 -0500
In-Reply-To: <1305290935-sup-4547@xo15-sascha.sascha.silbe.org>
References: <1305118354-17337-1-git-send-email-silbe@activitycentral.com>
	 <1305169898.8054.19.camel@dcbw.foobar.com>
	 <1305290935-sup-4547@xo15-sascha.sascha.silbe.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1305825421.3271.8.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-13 at 15:16 +0200, Sascha Silbe wrote:
> Excerpts from Dan Williams's message of Thu May 12 05:11:36 +0200 2011:
> > On Wed, 2011-05-11 at 14:52 +0200, Sascha Silbe wrote:
> > > This allows individual users and deployments to disable mesh support at
> > > runtime, i.e. without having to build and maintain a custom kernel.
> 
> > Does the mesh interface somehow cause problems, even when nothing is
> > using it?
> 
> Some people suspect it does, but there's no hard data showing that. But
> then the problems are often hard to reproduce in the first place, so
> proving a correlation with mesh is even harder.

That's not an excuse for not finding and fixing the problem though.
What problems are we actually talking about here?

> The hardware based mesh support is based on an outdated draft of
> 802.11s and not interoperable with any other device AFAIK. For most
> users Ad-hoc networks are the better option. Disabling mesh support as
> low-level as possible makes it less likely that any remains are causing
> trouble. With at least four layers (firmware, kernel, NM, Sugar)
> involved in managing connectivity and one of the (firmware) being closed
> source, I prefer to simplify things by eliminating three layers for
> functionality we don't intend to use. It makes debugging (and
> blaming ;) ) a lot easier.
> 
> In the field, mesh support is currently disabled using
> /sys/class/net/eth0/lbs_mesh. However, it comes back after resume
> (possibly only if powercycled) and needs to be disabled again by
> post-resume hacks. Race conditions with NM are possible.

That's a parameter handled by the driver; so shouldn't we make sure it's
respected again on resume?

> A user space option would be to teach NM to disable mesh support (at
> runtime - we don't want to ship a custom NM package). I'd expect the
> patch to be much more invasive than the one posted for libertas.

Not really, but we already have on/off for a bunch of other stuff, I
don't see why we can't add one for OLPC mesh.

Dan

