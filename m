Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab1I1IDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 04:03:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42179 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab1I1IDs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 04:03:48 -0400
Subject: Re: [PATCH 0/6] [RFC] Proposal for optimistic suspend idea.
From: Peter Zijlstra <peterz@infradead.org>
To: Richard Cochran <richardcochran@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>, lkml <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, arve@android.com,
        markgross@thegnar.org, Alan Stern <stern@rowland.harvard.edu>,
        amit.kucheria@linaro.org, farrowg@sg.ibm.com,
        "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 28 Sep 2011 10:02:55 +0200
In-Reply-To: <20110928075752.GA6670@netboy.at.omicron.at>
References: <1317064434-1829-1-git-send-email-john.stultz@linaro.org>
	 <1317068164.1763.39.camel@twins> <1317076065.3112.539.camel@work-vm>
	 <1317119870.15383.29.camel@twins> <1317164216.3112.711.camel@work-vm>
	 <1317196305.5781.5.camel@twins>
	 <20110928075752.GA6670@netboy.at.omicron.at>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317196975.5781.15.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 09:57 +0200, Richard Cochran wrote:
> On Wed, Sep 28, 2011 at 09:51:45AM +0200, Peter Zijlstra wrote:
> > SCHED_FIFO is an utter trainwreck, you're talking to the guy who gave a
> > conference talk on why SCHED_FIFO sucks.
> 
> That sounds interesting. Do you have a link to the paper and/or
> presentation?

Not really, I'm also the guy who doesn't write papers and has minimal
slides (and has lost those he had).

But the gist is that SCHED_FIFO doesn't provide proper resource control:
its possible to overload the system, nor does it provide proper resource
isolation: (like already stated) its impossible to fold two properly
working RT systems onto one machine and still have them work correctly
(even when the combined utilization < 1).
