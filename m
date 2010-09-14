Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab0INQB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 12:01:28 -0400
Received: from adelie.canonical.com ([91.189.90.139]:41587 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab0INQB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 12:01:26 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 0/1] x86: should 32 bit processes be PER_LINUX32
Date: Tue, 14 Sep 2010 17:00:56 +0100
Message-Id: <1284480057-18120-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While testing an x86 64 bit kernel on 32 bit userspace I noticed that I
was unexpectedly seeing x86_64 as the architecture as reported in uname.
The kernel seems to have code to detect 32 bit userspace and slam this
to i686, triggered off the personality PER_LINUX32.  However 32 bit
processes do not seem to get this flag.  I think this is an oversight.
The following patch attempts to fix this up.

-apw

Andy Whitcroft (1):
  x86: ensure we correctly advertise 32 bit processes in a 64 bit
    kernel

 arch/x86/kernel/process_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

