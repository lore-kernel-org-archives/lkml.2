Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab1HIPHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 11:07:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55708 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab1HIPHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 11:07:23 -0400
Date: Tue, 9 Aug 2011 17:06:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Garrett <mjg@redhat.com>
Cc: Jack Steiner <steiner@sgi.com>, tglx@linutronix.de, davej@redhat.com,
        yinghan@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86: Reduce clock calibration time during slave cpu
 startup
Message-ID: <20110809150624.GG28228@elte.hu>
References: <20110727135730.GA17717@sgi.com>
 <20110727140523.GA24206@redhat.com>
 <20110727141527.GA8453@sgi.com>
 <20110727155200.GA25381@redhat.com>
 <20110801184542.GA3939@sgi.com>
 <20110805104635.GB13055@elte.hu>
 <20110805131638.GA27779@sgi.com>
 <20110805213836.GB21114@elte.hu>
 <20110807003642.GA4442@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110807003642.GA4442@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -1.9
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.9 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.1 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew Garrett <mjg@redhat.com> wrote:

> On Fri, Aug 05, 2011 at 11:38:36PM +0200, Ingo Molnar wrote:
> 
> > Well, it still uses heuristics: it assumes frequency is the same 
> > when the cpuid data tells us that two CPUs are on the same 
> > socket, right?
> 
> If we only assume that when we have a constant TSC then it's a 
> pretty safe assumption - the delay loop will be calibrated against 
> the TSC, and the TSC will be constant across the package regardless 
> of what frequency the cores are actually running at.

The delay loop might be calibrated against the TSC, but the amount of 
real delay we get when we loop 100,000 times will be frequency 
dependent.

What we probably want is the most conservative udelay calibration: 
have a lpj value measured on the highest possible frequency - this 
way hardware components can never be overclocked by a driver.

Or does udelay() scale with the current frequency of the CPU?

Thanks,

	Ingo
