Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab0CWLv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 07:51:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:60626 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008Ab0CWLvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 07:51:23 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH 5/5] cpufreq: Add support for actual freq
Date: Tue, 23 Mar 2010 12:51:18 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: akpm@linux-foundation.org, davej@redhat.com, cpufreq@vger.kernel.org,
       x86@kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org
References: <1269283121-11894-1-git-send-email-bp@amd64.org> <1269283121-11894-6-git-send-email-bp@amd64.org>
In-Reply-To: <1269283121-11894-6-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201003231251.18181.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 March 2010 19:38:41 Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Modify the scaling_cur_freq interface to show the actual core frequency
> when boosting is supported and enabled on the core.
This looks wrong.

scaling_cur freq should show the frequency the kernel/cpufreq
subsystem thinks it's in.
You show the average freq and the time of the measured average
frequency depends on when the cpufreq subsystem called getavg()
the last time.
Also the time frame of the average freq the cpufreq subsystem
gets when calling getavg() now depends on whether and how often
userspace calls scaling_cur_freq which influences switching policy.

Latest cpufrequtils (ver 006) supports cpufreq-aperf to check whether
cores enter boost mode. Len Brown afaik also has a userspace tool, but
if it has any advantages, it should IMO get integrated into cpufrequtils
which people know to use when looking at cpufreq.

I once thought about adding scaling_avg_freq which gets an own
aperf_mperf counter, but you don't know whether another app read out the
average freq in between and your expected measured time frame is wrong then.
You could remember aperf/mperf per pid and free the saved aperf/mperf value
if the process dies..., but what for if this can be read out in userspace.

    Thomas
