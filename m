Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab1HIPSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 11:18:20 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:39896 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab1HIPST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 11:18:19 -0400
Date: Tue, 9 Aug 2011 16:18:10 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jack Steiner <steiner@sgi.com>, tglx@linutronix.de, davej@redhat.com,
        yinghan@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86: Reduce clock calibration time during slave cpu
 startup
Message-ID: <20110809151810.GA14795@srcf.ucam.org>
References: <20110727135730.GA17717@sgi.com>
 <20110727140523.GA24206@redhat.com>
 <20110727141527.GA8453@sgi.com>
 <20110727155200.GA25381@redhat.com>
 <20110801184542.GA3939@sgi.com>
 <20110805104635.GB13055@elte.hu>
 <20110805131638.GA27779@sgi.com>
 <20110805213836.GB21114@elte.hu>
 <20110807003642.GA4442@srcf.ucam.org>
 <20110809150624.GG28228@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110809150624.GG28228@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, 2011 at 05:06:24PM +0200, Ingo Molnar wrote:

> The delay loop might be calibrated against the TSC, but the amount of 
> real delay we get when we loop 100,000 times will be frequency 
> dependent.

We don't have a situation where a system boots with one core in a 
package fixed at one frequency and another core in the same package at 
another. It's possible that they'll float independently due to cpufreq 
changes (although that's not possible with most current hardware), but 
we need to take that into account anyway.

> What we probably want is the most conservative udelay calibration: 
> have a lpj value measured on the highest possible frequency - this 
> way hardware components can never be overclocked by a driver.

There's no way to force the highest possible frequency. Calibration 
occurs before cpuidle is running, and the only way to get the maximum 
frequency on a given core is to have all the other cores in C6.

> Or does udelay() scale with the current frequency of the CPU?

If it doesn't then it's been broken for the past 8 years or so.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
