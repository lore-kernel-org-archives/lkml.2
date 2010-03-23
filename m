Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab0CWOl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 10:41:56 -0400
Received: from isilmar.linta.de ([213.133.102.198]:49928 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753954Ab0CWOly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 10:41:54 -0400
Date: Tue, 23 Mar 2010 15:41:52 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Borislav Petkov <bp@amd64.org>
Cc: Thomas Renninger <trenn@suse.de>, akpm@linux-foundation.org,
       davej@redhat.com, cpufreq@vger.kernel.org, x86@kernel.org,
       linux-kernel@vger.kernel.org, lenb@kernel.org
Subject: Re: [PATCH 5/5] cpufreq: Add support for actual freq
Message-ID: <20100323144152.GA17587@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Borislav Petkov <bp@amd64.org>, Thomas Renninger <trenn@suse.de>,
	akpm@linux-foundation.org, davej@redhat.com,
	cpufreq@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, lenb@kernel.org
References: <1269283121-11894-1-git-send-email-bp@amd64.org> <1269283121-11894-6-git-send-email-bp@amd64.org> <201003231251.18181.trenn@suse.de> <20100323142349.GG16493@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100323142349.GG16493@aftab>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Tue, Mar 23, 2010 at 03:23:49PM +0100, Borislav Petkov wrote:
> > scaling_cur freq should show the frequency the kernel/cpufreq
> > subsystem thinks it's in.
> 
> Well, we have also
> /sys/devices/system/cpu/cpu<NUM>/cpufreq/cpuinfo_cur_freq and it reads
> also policy->cur.

No. cpuinfo_cur_freq calls __cpufreq_get() which itself calls the driver's
->get() callback, which is exactly for determining the current frequency. I
assume CPUFREQ_CONST_LOOP is set, else we'd get into trouble; but as long as
that's the case I see no problem in using ->get() / cpuinfo_cur_freq to read
out the current actual frequency.

> Why not show the actual frequency in scaling_cur_freq then?

Quoting Documentation/cpu-freq/user-guide.txt :

cpuinfo_cur_freq :              Current frequency of the CPU as obtained from
                                the hardware, in KHz. This is the frequency
                                the CPU actually runs at.

scaling_cur_freq :              Current frequency of the CPU as determined by
                                the governor and cpufreq core, in KHz. This is
                                the frequency the kernel thinks the CPU runs
                                at.

So scaling_cur_freq may not be mis-used for this; cpuinfo_cur_freq may be
used for it, though. IMVHO.

Best,
	Dominik
