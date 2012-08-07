Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334Ab2HGB4G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 21:56:06 -0400
Received: from linux-sh.org ([111.68.239.195]:38902 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932086Ab2HGB4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 21:56:04 -0400
Date: Tue, 7 Aug 2012 10:55:51 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: kuninori.morimoto.gx@renesas.com, Magnus Damm <magnus.damm@gmail.com>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
Subject: Re: [Regression, post-3.5] System suspend broken on the Mackerel
 board
Message-ID: <20120807015551.GB1614@linux-sh.org>
References: <20120801073004.GE15380@linux-sh.org>
 <201208050002.43465.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208050002.43465.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2012 at 12:02:43AM +0200, Rafael J. Wysocki wrote:
> On Wednesday, August 01, 2012, Paul Mundt wrote:
> > Turns out we can just collapse the probe/init stuff anyways, so this
> > ought to fix it. I've verified that it fixes Morimoto-san's issue, my
> > expectation is that the mackerel case is likewise getting tripped up but
> > no one bothered implementing any error detecting logic for gpio_request()
> > failing, so it doesn't fail gracefully.
> > 
> > I'll be pushing this out to Linus shortly:
> 
> Thanks, this helped.  Resume works correctly on Mackerel with 3.6-rc1.
> 
> However, I'm now seeing a different problem related to system suspend on that,
> board which is that sh7372_enter_a3sm_common() returns immediately, as though
> at least one of the wakeup signals was permanently asserted.  This hadn't
> happened before your last pull request was merged, so I suspect that one
> of the irqdomain patches might introduce this behavior.
> 
Ok, I'll back off the irqdomain selection until we have a chance to test
it more on the other platforms.
