Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab1CWLMg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 07:12:36 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59723 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326Ab1CWLMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 07:12:34 -0400
Date: Wed, 23 Mar 2011 11:12:20 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Kay Sievers <kay.sievers@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 9/10] sh: Use struct syscore_ops instead of sysdev
	class and sysdev
Message-ID: <20110323111220.GB27671@sirena.org.uk>
References: <201103100131.58206.rjw@sisk.pl> <201103222130.46603.rjw@sisk.pl> <1300826390.1815.5.camel@zag> <201103222200.52131.rjw@sisk.pl> <1300828356.1815.15.camel@zag> <20110322214922.GA7503@linux-sh.org> <1300831256.1815.22.camel@zag> <20110322222347.GA3978@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110322222347.GA3978@linux-sh.org>
X-Cookie: Oh, Aunty Em, it's so good to be home!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 07:23:48AM +0900, Paul Mundt wrote:
> On Tue, Mar 22, 2011 at 11:00:56PM +0100, Kay Sievers wrote:

> > Which is what we need to get rid of. It does not make any sense on the
> > global picture to have anything like that exported to userspace.

> So far I haven't heard any rationale for why it doesn't. Exporting CPU
> state to userspace certainly makes sense, and the sysdev model has worked
> reasonably for CPUs, memory nodes, etc.

FWIW it'd be really helpful to have CPUs (or at least SoCs) be regular
struct devices for integration with the regulator API so we can have all
things that might use a regulator (like DVFS) be struct devices but...

> Once cpufreq, timekeeping, and NUMA node state have migrated to whatever
> the driver model folks find acceptable, I'll happily follow suit.

...we're not precisely there yet :/
