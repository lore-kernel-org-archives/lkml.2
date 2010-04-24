Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab0DXCLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 22:11:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763Ab0DXCLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 22:11:48 -0400
Date: Fri, 23 Apr 2010 22:11:08 -0400
From: Dave Jones <davej@redhat.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.34-rc5-git3 - INFO: possible circular locking dependency
 detected - (s_active#91){++++.+}, at: [<ffffffff81142c4a>]
 sysfs_addrm_finish+0x31/0x50
Message-ID: <20100424021108.GB19662@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Miles Lane <miles.lane@gmail.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	LKML <linux-kernel@vger.kernel.org>,
	Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
References: <l2na44ae5cd1004231856gb03a023cnaf941169a044ab19@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <l2na44ae5cd1004231856gb03a023cnaf941169a044ab19@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 09:56:20PM -0400, Miles Lane wrote:
 > [ 2564.720395] Disabling non-boot CPUs ...
 > [ 2564.764388]
 > [ 2564.764391] =======================================================
 > [ 2564.764395] [ INFO: possible circular locking dependency detected ]
 > [ 2564.764400] 2.6.34-rc5-git3 #22
 > [ 2564.764403] -------------------------------------------------------
 > [ 2564.764408] pm-suspend/5388 is trying to acquire lock:
 > [ 2564.764412]  (s_active#91){++++.+}, at: [<ffffffff81142c4a>]
 > sysfs_addrm_finish+0x31/0x50
 > [ 2564.764432]
 > [ 2564.764434] but task is already holding lock:
 > [ 2564.764437]  (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}, at:
 > [<ffffffff8132dd4d>] lock_policy_rwsem_write+0x4a/0x7b
 > [ 2564.764450]
 > [ 2564.764451] which lock already depends on the new lock.
 > [ 2564.764454]


gah, this has been fixed in cpufreq.git for a while. I thought I'd
already pushed that along to Linus. I just sent him another pull request.

thanks,

	Dave

