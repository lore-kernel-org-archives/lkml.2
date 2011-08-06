Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab1HFLmx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 07:42:53 -0400
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:52132 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755543Ab1HFLmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 07:42:49 -0400
X-AuditID: 1209190c-b7bdeae000000a26-2a-4e3d285f1068
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Fenghua Yu <fenghua.yu@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v2 0/2] Forcibly enable some MISC_ENABLE features on Intel
Date: Sat,  6 Aug 2011 07:42:34 -0400
Message-Id: <cover.1312630712.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsUixCmqrBuvYetn0L1Z2aLvylF2i7ZpjhY7
	H75ls1i+r5/R4vKuOWwWWy41s1pcfTibxeLHhsesDhwet9r+MHvsnHWX3WPxnpdMHptWdbJ5
	rLvxld3j8ya5ALYoLpuU1JzMstQifbsEroyrtxcyF3xlq9j3fBNLA+N+1i5GTg4JAROJt+9+
	s0DYYhIX7q1n62Lk4hAS2Mco8eH3FShnPaPEmisvmSCcp0wSl+ddAGthE1CR6Fj6gAnEFhEw
	kNiy8gUrSBGzwBVGiYvzbzCDJIQFvCS+Ny4G28cioCpxcd1WsDivgL7Ena8/GCF2y0kcufyc
	aQIjzwJGhlWMsim5Vbq5iZk5xanJusXJiXl5qUW6hnq5mSV6qSmlmxjBQSbJs4PxzUGlQ4wC
	HIxKPLwPZWz8hFgTy4orcw8xSnIwKYnysqrb+gnxJeWnVGYkFmfEF5XmpBYfYpTgYFYS4c3R
	BSrnTUmsrEotyodJSXOwKInzlnv/9xUSSE8sSc1OTS1ILYLJynBwKEnwOgGjSUiwKDU9tSIt
	M6cEIc3EwQkynAdouB3IYt7igsTc4sx0iPwpRkUpcV5JkGYBkERGaR5cLywJvGIUB3pFmNcQ
	pIoHmEDgul8BDWYCGpz7BOTq4pJEhJRUA2ND2V4DhTjOnS+dWrgTnQz05S5NvSrdqG935FOU
	44HsbM8kzcU+KgtO7ykM0hfvf1Fx1Jn7xvbfIRkNU7x/tyaX+cySsvzy5EXCrrVT6tqmCrgo
	LPu7WkvNssrGbHLudcGfibr7Fcxj7s1MesCZrpO1wTri3LSFdpOOeDp3ZLRxqlhccrapUGIp
	zkg01GIuKk4EAD6zyfLdAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel allows BIOS or the OS to enable or disable some CPU fueatures via
IA32_MISC_ENABLE.  I have machines that don't enable fast strings or
monitor/mwait in BIOS, so do it on bootup instead.

The Intel SDM volume 3, appendix B.1 says that the OS should not touch
the monitor enable bit if SSE3 is not present, which presumably means
that the OS may touch that bit if SSE3 is present.  In any case, these
patches seem to work.

Changes from v1:
 - Display FW_WARN messages.
 - Don't change the kmemcheck message.
 - Improve the fast string comment.
 - Improve the changelogs.

Andy Lutomirski (2):
  x86: Enable fast strings on Intel if BIOS hasn't already
  x86: Enable monitor/mwait on Intel if BIOS hasn't already

 arch/x86/kernel/cpu/intel.c |   50 ++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 47 insertions(+), 3 deletions(-)

-- 
1.7.6

