Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab2KQOuh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 09:50:37 -0500
Received: from mail.skyhub.de ([78.46.96.112]:53638 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850Ab2KQOub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 09:50:31 -0500
Date: Sat, 17 Nov 2012 15:50:48 +0100
From: Borislav Petkov <bp@alien8.de>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        MyungJoo Ham <myungjoo.ham@gmail.com>
Subject: Re: [PATCH 3/6 v4] cpufreq: tolerate inexact values when collecting
 stats
Message-ID: <20121117145048.GI16441@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Mark Langsdorf <mark.langsdorf@calxeda.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	MyungJoo Ham <myungjoo.ham@gmail.com>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
 <1352313166-28980-1-git-send-email-mark.langsdorf@calxeda.com>
 <1352313166-28980-4-git-send-email-mark.langsdorf@calxeda.com>
 <20121111163821.GA21635@x1.osrc.amd.com>
 <50A12565.4070701@calxeda.com>
 <20121113162449.GE9327@x1.osrc.amd.com>
 <50A2766D.6040008@calxeda.com>
 <21672683C5A3814BB4DB938EBE482DE426EA988080@IAD2MBX09.mex02.mlsrvr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <21672683C5A3814BB4DB938EBE482DE426EA988080@IAD2MBX09.mex02.mlsrvr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 02:13:38PM -0500, Mark Langsdorf wrote:
> Although cpufreq_driver has a flag field, no part of cpufreq_driver
> is directly passed to the cpufreq_stat code. Only cpufreq_policy
> is. It's cleaner to do passes of the while loop than to copy the
> cpufreq_driver.flag field into cpufreq_policy and then store it again
> in cpufreq_stats.

That maybe so but this newly added loop which is only Calxeda-relevant
is called in cpufreq_stat_notifier_trans, which is the frequency change
notifier call, AFAICT.

So each cpufreq driver will be paying that small and needless penalty
now for nothing and on each frequency change. Which adds to the
kernel-wide bloat and we absolutely don't want that.

So you probably need to find a slick way of detecting calxeda hw
somewhere along the init path of cpufreq_stats_init and set a
hw-specific flag instead of adding that cost to each driver.

Thanks.

-- 
Regards/Gruss,
Boris.
