Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab2JQClS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 22:41:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755690Ab2JQClQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 22:41:16 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Arvind R ." <arvino55@gmail.com>
Subject: [PATCH EDAC 0/3] Fix i82975x_edac driver
Date: Tue, 16 Oct 2012 23:41:07 -0300
Message-Id: <cover.1350440633.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i82975x_edac driver is completely broken. I got a bug report
related to an OOPS caused by the recent changes there

After fixing it, I noticed weird behaviours at the driver on my
test machine, especially after enabling the EDAC debug logic.

In the end, the entire logic there that fills memory data were
broken, and also, the error report logic.

The worse bug there, IMHO, is that, during Corrected Errors,
it will only report the right DIMM in 50% of the cases, on
the more standard memory configuration (Dual channel, interleaved).

That happens because the logic were checking for bit 1, instead of
bit 6, in order to decide if the error belongs to channel A or to
channel B.

The patches on this series are:

	- patch 1: fixes the reported OOPS - it is a good candidate
for Kernel 3.7 and -stable;

	- patch 2: convert the already existing debug code
to use the standard way for debug (instead of requiring someone
to edit the source code to uncomment the debug macro);
So, the third patch on this series;

	- patch 3: rewrite the entire fill/report logic.

Patches got tested on a Dell Precision N390 and worked as expected.

Regards,
Mauro

Mauro Carvalho Chehab (3):
  i82975x_edac: Fix dimm label initialization
  i82975x_edac: Use the edac standard debug macro
  i82975x_edac: rewrite the entire fill/report logic

 drivers/edac/i82975x_edac.c | 457 ++++++++++++++++++++++++++------------------
 1 file changed, 272 insertions(+), 185 deletions(-)

-- 
1.7.11.7

