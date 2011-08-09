Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab1HIMlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 08:41:17 -0400
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:64152 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753180Ab1HIMlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 08:41:15 -0400
X-AuditID: 12074424-b7b0fae000000a08-54-4e412b0d5e77
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Fenghua Yu <fenghua.yu@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v3 0/2] Forcibly enable some MISC_ENABLE features on Intel
Date: Tue,  9 Aug 2011 08:41:04 -0400
Message-Id: <cover.1312893572.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsUixCmqrcur7ehnMGetskXflaPsFm3THC12
	PnzLZrF8Xz+jxeVdc9gstlxqZrW4+nA2i8WPDY9ZHTg8brX9YfbYOesuu8fiPS+ZPDat6mTz
	WHfjK7vH501yAWxRXDYpqTmZZalF+nYJXBl3fx1lKpjIUbHh7l+WBsbdbF2MnBwSAiYS83c8
	YoawxSQu3FsPFhcS2McocfNPVRcjF5C9nlFix+8NbBDOUyaJtjlfGUGq2ARUJDqWPmACsUUE
	DCS2rHzBClLELHCFUeLi/BtgY4UFvCT+H/4LlODgYBFQlehbLg1i8groS7z5YwexWE7iyOXn
	TBMYeRYwMqxilE3JrdLNTczMKU5N1i1OTszLSy3SNdfLzSzRS00p3cQICi92F5UdjM2HlA4x
	CnAwKvHwcvA7+AmxJpYVV+YeYpTkYFIS5X2i6egnxJeUn1KZkVicEV9UmpNafIhRgoNZSYQ3
	XQMox5uSWFmVWpQPk5LmYFES57XZCTRJID2xJDU7NbUgtQgmK8PBoSTBm6EF1ChYlJqeWpGW
	mVOCkGbi4AQZzgM0XBSkhre4IDG3ODMdIn+KUVFKnNcWJCEAksgozYPrhcX/K0ZxoFeEeYVB
	qniAqQOu+xXQYCagwfV3HEAGlyQipKQaGLWv75zmwb801P1l80nTuSsca0QYA91mveeO4vza
	uOnb3LemG3fui3OZuKasVIDHMFau9UOmsmeHC1fREfnY72IZ9xR0aryTH9sduCmRpngzS19K
	dNGqYJkFV8L+px5+IiW47kHUzFATQZuFx9c3Pp8a2ets0nKD4fKsYxbNb+bOeRjyg7F6qhJL
	cUaioRZzUXEiAFM8Kr7aAgAA
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

Changes from v2:
 - Don't linebreak printk messages (for ease of grepping)
 - Use printk_once
 - Update the "Disabled fast string operations" message

Changes from v1:
 - Display FW_WARN messages.
 - Don't change the kmemcheck message.
 - Improve the fast string comment.
 - Improve the changelogs.

Andy Lutomirski (2):
  x86: Enable fast strings on Intel if BIOS hasn't already
  x86: Enable monitor/mwait on Intel if BIOS hasn't already

 arch/x86/kernel/cpu/intel.c |   52 ++++++++++++++++++++++++++++++++++++++----
 1 files changed, 47 insertions(+), 5 deletions(-)

-- 
1.7.6

