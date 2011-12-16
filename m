Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760859Ab1LPV7k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 16:59:40 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34600 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760426Ab1LPV7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 16:59:31 -0500
From: Marek Vasut <marek.vasut@gmail.com>
To: joe@perches.com
Subject: checkpatch.pl misreporting bugs with array fillings
Date: Fri, 16 Dec 2011 22:59:28 +0100
User-Agent: KMail/1.13.7 (Linux/3.1.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112162259.29043.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the following testcase is probably misreported by checkpatch.pl:

static const unsigned char pci_irq_swizzle[2][PCI_MAX_DEVICES] = {
        {0, 0, 0, 0, 0, 0, 0, 27, 27, [9 ... PCI_MAX_DEVICES - 1] = 0 },
        {0, 0, 0, 0, 0, 0, 0, 29, 29, [9 ... PCI_MAX_DEVICES - 1] = 0 },
};

The result is:

ERROR: space prohibited before open square bracket '['
#2: FILE: testcase.c:2:
+       {0, 0, 0, 0, 0, 0, 0, 27, 27, [9 ... PCI_MAX_DEVICES - 1] = 0 },

ERROR: space prohibited before open square bracket '['
#3: FILE: testcase.c:3:
+       {0, 0, 0, 0, 0, 0, 0, 29, 29, [9 ... PCI_MAX_DEVICES - 1] = 0 },

total: 2 errors, 0 warnings, 5 lines checked

NOTE: Ignored message types: COMPLEX_MACRO CONSIDER_KSTRTO MINMAX 
MULTISTATEMENT_MACRO_USE_DO_WHILE

testcase.c has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Cheers!
M
