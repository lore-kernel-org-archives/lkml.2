Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab2KZPUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 10:20:19 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:33675 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753752Ab2KZPUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 10:20:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-pm@vger.kernel.org
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        MyungJoo Ham <myungjoo.ham@gmail.com>
Subject: Re: [PATCH 3/6 v4] cpufreq: tolerate inexact values when collecting stats
Date: Mon, 26 Nov 2012 16:25:01 +0100
Message-ID: <2830056.M1sSqgI0LP@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc7; KDE/4.9.3; x86_64; ; )
In-Reply-To: <50B3754A.50804@calxeda.com>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com> <3756540.1nyvqzWibd@vostro.rjw.lan> <50B3754A.50804@calxeda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 26, 2012 07:57:30 AM Mark Langsdorf wrote:
> On 11/24/2012 04:05 AM, Rafael J. Wysocki wrote:
> > On Saturday, November 17, 2012 03:50:48 PM Borislav Petkov wrote:
> >> On Tue, Nov 13, 2012 at 02:13:38PM -0500, Mark Langsdorf wrote:
> >>> Although cpufreq_driver has a flag field, no part of cpufreq_driver
> >>> is directly passed to the cpufreq_stat code. Only cpufreq_policy
> >>> is. It's cleaner to do passes of the while loop than to copy the
> >>> cpufreq_driver.flag field into cpufreq_policy and then store it again
> >>> in cpufreq_stats.
> >>
> >> That maybe so but this newly added loop which is only Calxeda-relevant
> >> is called in cpufreq_stat_notifier_trans, which is the frequency change
> >> notifier call, AFAICT.
> 
> Drivers only go through the loop if they can't find an exact frequency.
> So every driver that isn't Calxeda shouldn't see the issue.
> 
> >> So you probably need to find a slick way of detecting calxeda hw
> >> somewhere along the init path of cpufreq_stats_init and set a
> >> hw-specific flag instead of adding that cost to each driver.
> > 
> > Mark, I suppose you'd like me to take this series for v3.8, but the above
> > comment from Boris has to be addressed for that.
> 
> I think I'd rather drop this particular patch and not have cpufreq_stat
> support for Highbank. Redesigning it to meet Boris' requirements is
> going to take more time than I currently have available.
> 
> Would it be acceptable to drop this patch and fix the issues with
> patches 4 and 6 to get the series in?

Yes, it would, but please resubmit ASAP.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
