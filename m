Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab2EVN1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 09:27:10 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:33999 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751508Ab2EVN1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 09:27:07 -0400
From: sjur.brandeland@stericsson.com
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFC 0/6] remoteproc: custom fw handling
Date: Tue, 22 May 2012 15:26:51 +0200
Message-Id: <1337693217-15466-1-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Hi Ohad.

I have cooked a couple of patches for remoteproc. I was planning to
test and polish them some more, but figured that I might as well send
them and find out what you think.

First patch is a trivial fix for print formatting warnings (gcc 4.6.1)

The next five patches are about custom firmware handlers.
I have done this in small steps to facilitate review, but I
suspect you might want to squash them all together.

The three first patches are just preparation. The fourth patch
is the most interesting one, doing firmware loaders customizable.
The last is optional, it makes the ELF loader into a separate module.

Note that the ELF loaders are not tested. I have no environment to test
this at the moment.

Regards,
Sjur


Sjur Brændeland (6):
  remoteproc: fix print format warnings
  remoteproc: Pass struct fw to load_segments and find_rsc_table.
  remoteproc: Move fw sanity check to find_rsc_table.
  remoteproc: Move Elf related functions to separate file
  remoteproc: Support custom firmware handlers
  remoteproc: Make REMOTEPROC_ELF a sparate Kconfig

 drivers/remoteproc/Kconfig                 |    6 +
 drivers/remoteproc/Makefile                |    1 +
 drivers/remoteproc/omap_remoteproc.c       |    1 +
 drivers/remoteproc/remoteproc_core.c       |  278 +++------------------------
 drivers/remoteproc/remoteproc_elf_loader.c |  282 ++++++++++++++++++++++++++++
 include/linux/remoteproc.h                 |   21 +++
 6 files changed, 334 insertions(+), 255 deletions(-)
 create mode 100644 drivers/remoteproc/remoteproc_elf_loader.c

-- 
1.7.9.5

