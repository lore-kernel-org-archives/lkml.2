Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab1CYK5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 06:57:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52495 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363Ab1CYK5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 06:57:11 -0400
Subject: Re: Deadlock scenario in regulator core
From: Peter Zijlstra <peterz@infradead.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        David Collins <collinsd@codeaurora.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20110323104230.GA778@opensource.wolfsonmicro.com>
References: <4D891C59.1030009@codeaurora.org>
	 <20110322223702.GO14675@home.goodmis.org> <4D892C0A.1090606@codeaurora.org>
	 <1300835998.14261.13.camel@gandalf.stny.rr.com>
	 <20110323000100.GB2529@opensource.wolfsonmicro.com>
	 <1300840734.14261.72.camel@gandalf.stny.rr.com>
	 <20110323104230.GA778@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Mar 2011 11:59:16 +0100
Message-ID: <1301050756.2250.190.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-23 at 10:42 +0000, Mark Brown wrote:
> 
> That's helpful, though it doesn't really say anything about how one
> picks subclass? 

With care ;-)

Its most useful for recursive use of the same lock class, typically we
only have 2 locks held and we can use the SINGLE_DEPTH_NESTING thing.
Some few sites use subclasses for larger things, some are ok, some are
dubious (ext4 comes to mind).

And like said in the other email, be careful with lockdep annotations,
you can actually annotate real deadlocks away.

