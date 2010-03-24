Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab0CXRPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:15:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:5059 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab0CXRPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:15:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=paVqpx+mTCu4Kgj6xDWtUzSwJ36D7xT/R7lm2Ewn3XY0V8bpIKoIINcYtUPT9qbLxT
         kOCtpROtAeATkiM6IFz8mml5ACQGWFGYP05FEI3dk8IRVjG7dKHuH0lEz1n1k+fr7ZzI
         FX975bGCc7iPIJvPrZUhVCsvuKe+2OmqXZwvY=
From: Manuel Lauss <manuel.lauss@googlemail.com>
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-mips@linux-mips.org, Manuel Lauss <manuel.lauss@gmail.com>
Subject: [RFC PATCH 0/2] serial 8250 platform PM hooks
Date: Wed, 24 Mar 2010 18:16:24 +0100
Message-Id: <1269450986-3714-1-git-send-email-manuel.lauss@gmail.com>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following 2 patches implement a PM hook for platform 8250
UARTs and a sample PM implementation for a MIPS SoC.

Patch #1 hooks a new .pm callback in struct plat_serial8250_port to
the rest of serial_core's PM infrastructure,

Patch #2 implements uart power gating for Alchemy line of mips socs
using the new hook.

With these 2 patches serial console on my test system survives
suspend/resume cycles without having to resort to platform-specific
hacks in the PM code.

Thanks,
     Manuel Lauss

Manuel Lauss (2):
  8250: allow platform uarts to install PM callback.
  Alchemy: UART PM through serial framework.

 arch/mips/alchemy/common/platform.c |   17 +++++++++++++++++
 arch/mips/alchemy/common/power.c    |   32 --------------------------------
 drivers/serial/8250.c               |   31 ++++++++++++++++++++++++++++---
 include/linux/serial_8250.h         |    6 ++++++
 4 files changed, 51 insertions(+), 35 deletions(-)

