Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab1K1Orl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 09:47:41 -0500
Received: from gherkin.frus.com ([192.158.254.49]:58224 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291Ab1K1Ork (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 09:47:40 -0500
Date: Mon, 28 Nov 2011 08:47:38 -0600
From: Bob Tracy <rct@gherkin.frus.com>
To: Borislav Petkov <bp@amd64.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 3.2-rcX regression: boot failure on AMD K6-III/450
Message-ID: <20111128144738.GA3119@gherkin.frus.com>
References: <20111126181724.GA1993@gherkin.frus.com> <20111128140143.GA4522@x1.osrc.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128140143.GA4522@x1.osrc.amd.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 03:01:43PM +0100, Borislav Petkov wrote:
> can you try the following patch:
> (...)
> bcb80e53877c ("x86, microcode, AMD: Add microcode revision to
> /proc/cpuinfo") added support for dumping microcode patch level in
> /proc/cpuinfo on AMD. Although we were very cautious and did rdmsr_safe
> the microcode patch level MSR, this broke booting on Geode LX because
> this CPU doesn't have that MSR and at the time we do the read, exception
> tables which are used by rdmsr_safe are not yet initialized, leading to
> the boot hang.
> 
> This is the simple fix which enables the microcode line in /proc/cpuinfo
> for K8 and newer (it is not that interesting for older boxes anyway :-)).
> 
> Reported-and-bisected-and-tested-by: Daniel Drake <dsd@laptop.org>
> Link: http://lkml.kernel.org/r/CAMLZHHTSuHZoPbm_YfB8G05JA+xKCE4+Jmj4NW8mnZUHogQSBA@mail.gmail.com
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

That fixed it.  Thank you!

--Bob
