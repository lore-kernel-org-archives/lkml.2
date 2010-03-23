Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab0CWOsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 10:48:00 -0400
Received: from isilmar.linta.de ([213.133.102.198]:54838 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754134Ab0CWOr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 10:47:58 -0400
Date: Tue, 23 Mar 2010 15:47:57 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Borislav Petkov <bp@amd64.org>
Cc: Thomas Renninger <trenn@suse.de>, akpm@linux-foundation.org,
       davej@redhat.com, cpufreq@vger.kernel.org, x86@kernel.org,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/5] powernow-k8: Add core performance boost support
Message-ID: <20100323144757.GB17587@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Borislav Petkov <bp@amd64.org>, Thomas Renninger <trenn@suse.de>,
	akpm@linux-foundation.org, davej@redhat.com,
	cpufreq@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <1269283121-11894-1-git-send-email-bp@amd64.org> <1269283121-11894-3-git-send-email-bp@amd64.org> <201003231217.16451.trenn@suse.de> <20100323115858.GC16493@aftab> <20100323132737.GA8894@isilmar.linta.de> <20100323141934.GF16493@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100323141934.GF16493@aftab>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Borislav,

On Tue, Mar 23, 2010 at 03:19:34PM +0100, Borislav Petkov wrote:
> From: Dominik Brodowski <linux@dominikbrodowski.net>
> Date: Tue, Mar 23, 2010 at 02:27:37PM +0100
> 
> Hi Dominik,
> 
> > On Tue, Mar 23, 2010 at 12:58:58PM +0100, Borislav Petkov wrote:
> > > > It could already be set in arch/x86/kernel/cpu/amd.c and
> > > > powernow-k8 could use cpu_has(cpu, X86_FEATURE_CPB);
> > > 
> > > I'd still like to cache the cpb_capable value locally instead of getting
> > > x86_cpuinfo percpu var and querying it. Especially if this happens often
> > > and not only at driver init.
> > 
> > If it's a percpu var, isn't it local anyway?
> 
> I meant driver-local. So that I don't have to deref even the per_cpu var
> and thus save some cycles.

Well, it doesn't seem to be used in any hot path (and if it were, using a
per-cpu var was better anyway, because of no contention etc.). If it really
saves some cycles, I'm more than fine with keeping it; still, informing the
user in /proc/cpuinfo seems like a sensible thing to do.

Best,
	Dominik
