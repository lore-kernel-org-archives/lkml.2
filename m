Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab1EXIOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 04:14:42 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38735 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754265Ab1EXIOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 04:14:40 -0400
Date: Tue, 24 May 2011 10:14:34 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        "Huang, Ying" <ying.huang@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC 0/9] mce recovery for Sandy Bridge server
Message-ID: <20110524081434.GA18863@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@elte.hu>, "Luck, Tony" <tony.luck@intel.com>,
	linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
	Andi Kleen <andi@firstfloor.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <4ddad79317108eb33d@agluck-desktop.sc.intel.com>
 <20110524034023.GB25230@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110524034023.GB25230@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 05:40:23AM +0200, Ingo Molnar wrote:
> So we *really* want to promote this code to a higher level of abstraction. 
> Everyone would benefit from doing that: Intel hardware error handling features 
> would be enabled much more richly and i suspect they would also be *used* in a 
> much more meaningful way - driving the hw cycle as well.

Absolutely agreed. The RAS architecture should look like this, IMHO:

I. Event collection: #MC handler and pollers, no queueing or buffering crap.

II. Pluggable and extensible filters which are
* per vendor
* configurable from userspace
* easily extensible
* decide whether action should be taken in the kernel or error is non-critical
and should go to RAS daemon

III. Error handling callback(s)
* also extensible
* also per vendor
* also configurable from userspace

Advantages:
* reuse perf code - no need for ad-hoc new buffers and lockless thingies when we
have it all already

* easy code and even hw testing with perf inject or ras inject
** this gives us also the different injection methods per vendor in an unified
way instead of interfaces in /sys or debugfs or mcelog or ...

* keep code design sane instead of letting it needlessly fiddle with
other parts of the kernel

* ...

Now I should better go and put my patches where my mouth is :).

-- 
Regards/Gruss,
    Boris.
