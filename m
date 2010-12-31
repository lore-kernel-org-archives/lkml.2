Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab0LaRi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 12:38:58 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:36755 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab0LaRi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 12:38:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:reply-to:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=SQDdbRH9PYkW6J2G3MPOchCY9a4cCLcHxXaGqPk7cFoqSn6KQ3cz9zt5ClmNJV85eq
         laTvZTa5vCpujOHPcJ3TtHde1OGUQ6/FEcXC7aVYPI+xex/Fmp4MN1aI4bwPc0geTS8F
         GHl+Nc9d0/kUsNBHooNgTckSQ3Uv/RSB26WqY=
Date: Fri, 31 Dec 2010 19:38:58 +0200
From: Yotam Medini <yotam.medini@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: APM_CONFIG on x86 - Is it possible?
Message-ID: <20101231193858.2c742025@janini.home>
Reply-To: yotam.medini@gmail.com
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

To an ancient target (my UMAX 530T ActionBook - plz don't laugh...)
I am trying to build a lean kernel based on 2.6.32.24 (~ Ubuntu 10.04).
Battery monitoring used to be based on /proc/apm.
I believe ACPI is not supported on this old notebook.
Now, it seems that  CONFIG_APM_POWER  cannot be set, since:

1. The configuration place for  APM_POWER  is in:
   ./drivers/power/Kconfig:25:
	config APM_POWER
		tristate "APM emulation for class batteries"
		depends on APM_EMULATION

2. The configuration place for  APM_EMULATION  is in:
    ./kernel/power/Kconfig:201:
    config APM_EMULATION
	    tristate "Advanced Power Management Emulation"
	    depends on PM && SYS_SUPPORTS_APM_EMULATION

3. But the configuration places for the latter -  
      SYS_SUPPORTS_APM_EMULATION
  - exists only in:
    ./arch/powerpc/Kconfig:185:config SYS_SUPPORTS_APM_EMULATION
    ./arch/sh/Kconfig:120:config SYS_SUPPORTS_APM_EMULATION
    ./arch/mips/Kconfig:896:config SYS_SUPPORTS_APM_EMULATION
    ./arch/arm/Kconfig:32:config SYS_SUPPORTS_APM_EMULATION
  and none under arch/x86 ! :():

So my bottom line questions are:
+ Am I missing something?
+ What is the 'right way' to configure a 2.6.3m.nn kernel
  that should support battery monitoring on such ancient laptops.

When replying, please CC: yotam DOT medini AT Gmail DOT c0m
regards -- yotam
