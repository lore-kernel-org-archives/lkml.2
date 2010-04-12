Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab0DLX2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 19:28:44 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:58918 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab0DLX2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 19:28:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=XQQlLQK1WC9TYadquOmDAHyZ+7IKMXCucvMoxZW5w/oVvdR4bWPDqt8/FW7M1sn5NM
         OYZ4cqNypTrpQRIfPqC1U17QJ8R0smpc9BE/s0Y0LmA1Ij1s3kKlyLJjr1Rzu8Au7Iam
         vs0I7y1/gGv94osfdHcSB1CGyCXbsT7ZAC94c=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Will Deacon <will.deacon@arm.com>,
       Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: [RFC PATCH 0/2] hw-breakpoints allocation constraints updates
Date: Tue, 13 Apr 2010 01:01:18 +0200
Message-Id: <1271113280-10521-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

These patches tend to extend the breakpoint allocation constraints to
be more non-x86 friendly.

It can separate the data and instruction breakpoint space and
handle address ranges or other kind of tricky things that makes
a breakpoint use more than one address register.

There is still one kind of constraint it can't handle, something
I've found on ARMv7 implementation: linking an breakpoint to a
watchpoint. But if this needs arises, I will be glad to add that
support.

Beware, it's only compile-tested for now.

Tell me what you think.

Thanks.


Frederic Weisbecker (2):
  hw-breakpoints: Separate constraint space for data and instruction
    breakpoints
  hw-breakpoints: Handle breakpoint weight in allocation constraints

 arch/Kconfig                  |   11 ++++
 arch/x86/Kconfig              |    1 +
 include/linux/hw_breakpoint.h |    9 ++-
 kernel/hw_breakpoint.c        |  129 ++++++++++++++++++++++++++++++-----------
 4 files changed, 112 insertions(+), 38 deletions(-)

