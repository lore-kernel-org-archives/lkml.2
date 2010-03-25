Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab0CYU7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 16:59:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:57231 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab0CYU7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 16:59:53 -0400
From: Thomas Renninger <trenn@suse.de>
To: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH 3/5] cpufreq: Add APERF/MPERF support for AMD processors
Date: Thu, 25 Mar 2010 21:59:31 +0100
User-Agent: KMail/1.9.10
Cc: Borislav Petkov <bp@amd64.org>, akpm@linux-foundation.org,
       davej@redhat.com, linux@dominikbrodowski.net, mingo@elte.hu,
       hpa@zytor.com, tglx@linutronix.de, cpufreq@vger.kernel.org,
       x86@kernel.org, linux-kernel@vger.kernel.org
References: <1269452783-966-1-git-send-email-bp@amd64.org> <201003251043.04867.trenn@suse.de> <13218.1269546919@localhost>
In-Reply-To: <13218.1269546919@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003252159.31883.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 March 2010 08:55:19 pm Valdis.Kletnieks@vt.edu wrote:
> On Thu, 25 Mar 2010 10:43:04 BST, Thomas Renninger said:
> > > +	if (c->cpuid_level >= 6) {
> >
> > and remove this (arch/x86/kernel/cpu/intel.c):
> >         if (c->cpuid_level > 6) {
>
> So is > or >= the correct comparator here?

This one: >= is correct (for both).
I double checked, there is one Intel CPU type
having a cpuid_level of 6, but this would not support aperf/mperf, thus
above is still fine.

The remaining question is what Borislav said:
are there other x86 CPU vendors who could use this differently.
I very much expect there are not.

IMO you should resubmit this one or the whole series with this change
and Dave should just push this in his tree and queue it up, there was enough
time to object.

Thanks,

      Thomas
