Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab0IYXdS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 19:33:18 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:46800 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab0IYXdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 19:33:16 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hugh@veritas.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>
Date: Sat, 25 Sep 2010 16:33:09 -0700
Message-ID: <m1sk0x9z62.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH 0/3] Generic support for revoking mappings
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


During hotplug or rmmod if a device or file is mmaped, it's mapping
needs to be removed and future access need to return SIGBUS almost like
truncate.  This case is rare enough that it barely gets tested, and
making a generic implementation warranted.  I have tried with sysfs but
a complete and generic implementation does not seem possible without mm
support.

It looks like a fully generic implementation with mm knowledge
is shorter and easier to get right than what I have in sysfs today.

So here is that fully generic implementation.

Eric W. Biederman (3):
      mm: Introduce revoke_mappings.
      mm: Consolidate vma destruction into remove_vma.
      mm: Cause revoke_mappings to wait until all close methods have completed.
---
 include/linux/fs.h |    2 +
 include/linux/mm.h |    2 +
 mm/Makefile        |    2 +-
 mm/mmap.c          |   34 +++++-----
 mm/nommu.c         |    5 ++
 mm/revoke.c        |  192 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 219 insertions(+), 18 deletions(-)

Eric
