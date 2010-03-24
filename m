Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269Ab0CXOCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 10:02:34 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58926 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab0CXOCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 10:02:32 -0400
Date: Wed, 24 Mar 2010 15:02:57 +0100
From: Borislav Petkov <bp@amd64.org>
To: Thomas Renninger <trenn@suse.de>
Cc: akpm@linux-foundation.org, davej@redhat.com, cpufreq@vger.kernel.org,
       x86@kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org
Subject: Re: [PATCH 5/5] cpufreq: Add support for actual freq
Message-ID: <20100324140257.GA29754@aftab>
References: <1269283121-11894-1-git-send-email-bp@amd64.org>
 <201003231251.18181.trenn@suse.de>
 <20100323142349.GG16493@aftab>
 <201003231612.18907.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003231612.18907.trenn@suse.de>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Renninger <trenn@suse.de>
Date: Tue, Mar 23, 2010 at 04:12:18PM +0100

Hi Thomas,

> would return the average freq of the last seconds, exactly the same
> what you can do with cpufreq-aperf from userspace.
> But if another user app does the same, it's messed up.
> You can find out the pid of the process doing the cat and remember
> aperf/mperf for it if it does not exist yet..., but now it gets to a
> point where cpufreq-aperf is really more convenient and straight foward.
> 
> Possibly documenting cpufreq-aperf in Documentation/cpu-freq would
> be worth it. Also mentioning "boost" somewhere would be great:
> grep -i boost Documentation/cpu-freq/ -r
> Documentation/cpu-freq/pcc-cpufreq.txt:This is due to "turbo boost" ...
> 
> Another idea is to have a separate cpufreq_avg_freq and update it on
> every target() call, but that's overhead...

you got me persuaded - if we want to have the effective frequency
reported in the kernel, we have to come up with a slick solution that
wouldn't incur overhead and won't be disrupted by others accessing those
MSRs. Let's leave it to cpufreq-aperf for now and revisit this when
needed.

Thanks.

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
