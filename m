Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab1EGGel (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 02:34:41 -0400
Received: from smtp-out.google.com ([74.125.121.67]:50547 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab1EGGcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 02:32:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject;
	b=fP8CDfTZfafbuh3lA9Qmp6ZxjcFVPrl0mpSkHRvQG8sIo+hf64Wi8P7eXhcTO4Yda
	HebWQCzfRDK8hlg4N64pA==
Message-Id: <20110503092846.022272244@google.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 May 2011 02:28:46 -0700
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Subject: [patch 00/15] CFS Bandwidth Control V6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Apologies if you're receiving this twice, the previous mailing did not seem 
to make it to the list for some reason ].

Hi all,

Please find attached the latest iteration of bandwidth control (v6).

Where the previous release cleaned up many of the semantics surrounding the
update_curr() path and throttling, this release is focused on cleaning up the
patchset itself.  Elements such as the notion of expiring bandwidth from
previous quota periods as well as some of the core accounting changes have
been pushed up (and re-written for clarity) within the patchset reducing the
patch-to-patch churn significantly.

While this restructuring was fairly extensive in terms of the code touched,
there are no major behavioral changes beyond bug fixes.

Thanks to Hidetoshi Seto for identifying the throttle list corruption.

Notable changes:
- Runtime is now actively expired taking advantage of the bounds placed on
  sched_clock syncrhonization.
- distribute_cfs_runtime() no longer races with throttles around the period
  boundary.
- Major code cleanup

Bug fixes:
- several interactions with active load-balance have been corrected.  This was
  manifesting previously in throttle_list corruption and crashes.

Interface:
----------
Three new cgroupfs files are exported by the cpu subsystem:
  cpu.cfs_period_us : period over which bandwidth is to be regulated
  cpu.cfs_quota_us  : bandwidth available for consumption per period
  cpu.stat          : statistics (such as number of throttled periods and
                      total throttled time)
One important interface change that this introduces (versus the rate limits
proposal) is that the defined bandwidth becomes an absolute quantifier.

Previous postings:
-----------------
v5:
https://lkml.org/lkml/2011/3/22/477
v4:
https://lkml.org/lkml/2011/2/23/44
v3:
https://lkml.org/lkml/2010/10/12/44
v2:
http://lkml.org/lkml/2010/4/28/88
Original posting:
http://lkml.org/lkml/2010/2/12/393

Prior approaches:
http://lkml.org/lkml/2010/1/5/44 ["CFS Hard limits v5"]

Thanks,

- Paul


