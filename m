Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306Ab1KQPii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 10:38:38 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:39927 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932198Ab1KQPih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 10:38:37 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+seWgw1oSsYWOix7fW0lu2kyHHyhyhnq12IPub5F
	WqjJX/PzoOufJ1
Subject: Re: sched: Avoid SMT siblings in select_idle_sibling() if possible
From: Mike Galbraith <efault@gmx.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
In-Reply-To: <1321495153.5100.7.camel@marge.simson.net>
References: <1321350377.1421.55.camel@twins>
	 <1321406062.16760.60.camel@sbsiddha-desk.sc.intel.com>
	 <1321435455.5072.64.camel@marge.simson.net>
	 <1321468646.11680.2.camel@sbsiddha-desk.sc.intel.com>
	 <1321495153.5100.7.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Nov 2011 16:38:33 +0100
Message-ID: <1321544313.6308.25.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-17 at 02:59 +0100, Mike Galbraith wrote:
> On Wed, 2011-11-16 at 10:37 -0800, Suresh Siddha wrote:

> > It should be ok. Isn't it?
> 
> Nope, wasn't ok.

Because you can't get to again: with a single E5620 package, it having
only SIBLING and MC domains.
 
again:
        for_each_domain(target, sd) {
                if (!smt && (sd->flags & SD_SHARE_CPUPOWER))
                        continue;

                if (!(sd->flags & SD_SHARE_PKG_RESOURCES)) {
                        if (!smt) {
                                smt = 1;
                                goto again;

