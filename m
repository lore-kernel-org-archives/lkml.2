Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370Ab2KXKAl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 05:00:41 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:35788 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314Ab2KXKAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 05:00:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        MyungJoo Ham <myungjoo.ham@gmail.com>
Subject: Re: [PATCH 3/6 v4] cpufreq: tolerate inexact values when collecting stats
Date: Sat, 24 Nov 2012 11:05:09 +0100
Message-ID: <3756540.1nyvqzWibd@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc6; KDE/4.9.3; x86_64; ; )
In-Reply-To: <20121117145048.GI16441@x1.osrc.amd.com>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com> <21672683C5A3814BB4DB938EBE482DE426EA988080@IAD2MBX09.mex02.mlsrvr.com> <20121117145048.GI16441@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 17, 2012 03:50:48 PM Borislav Petkov wrote:
> On Tue, Nov 13, 2012 at 02:13:38PM -0500, Mark Langsdorf wrote:
> > Although cpufreq_driver has a flag field, no part of cpufreq_driver
> > is directly passed to the cpufreq_stat code. Only cpufreq_policy
> > is. It's cleaner to do passes of the while loop than to copy the
> > cpufreq_driver.flag field into cpufreq_policy and then store it again
> > in cpufreq_stats.
> 
> That maybe so but this newly added loop which is only Calxeda-relevant
> is called in cpufreq_stat_notifier_trans, which is the frequency change
> notifier call, AFAICT.
> 
> So each cpufreq driver will be paying that small and needless penalty
> now for nothing and on each frequency change. Which adds to the
> kernel-wide bloat and we absolutely don't want that.
> 
> So you probably need to find a slick way of detecting calxeda hw
> somewhere along the init path of cpufreq_stats_init and set a
> hw-specific flag instead of adding that cost to each driver.

Mark, I suppose you'd like me to take this series for v3.8, but the above
comment from Boris has to be addressed for that.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
