Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083Ab0G2Qsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 12:48:52 -0400
Received: from imr1.ericy.com ([198.24.6.9]:36399 "EHLO imr1.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754739Ab0G2Qsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 12:48:50 -0400
Subject: alpha defconfig build broken in 2.6.35-rc6
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
CC: "Morten H. Larsen" <m-larsen@post6.tele.dk>,
        Matt Turner <mattst88@gmail.com>, Richard Henderson <rth@twiddle.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Thu, 29 Jul 2010 09:48:42 -0700
Message-ID: <1280422122.17322.14.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During unrelated testing, I noticed that the alpha defconfig build is
broken in 2.6.35-rc6. I get the following error message.

arch/alpha/kernel/built-in.o: In function `cia_cab_init_pci':
/opt/scratch/groeck/linux-2.6/arch/alpha/kernel/sys_cabriolet.c:249:
undefined reference to `ns87312_enable_ide'
/opt/scratch/groeck/linux-2.6/arch/alpha/kernel/sys_cabriolet.c:249:
undefined reference to `ns87312_enable_ide'
arch/alpha/kernel/built-in.o: In function `cabriolet_init_pci':
/opt/scratch/groeck/linux-2.6/arch/alpha/kernel/sys_cabriolet.c:242:
undefined reference to `ns87312_enable_ide'
/opt/scratch/groeck/linux-2.6/arch/alpha/kernel/sys_cabriolet.c:242:
undefined reference to `ns87312_enable_ide'
arch/alpha/kernel/built-in.o: In function `takara_init_pci':
/opt/scratch/groeck/linux-2.6/arch/alpha/kernel/sys_takara.c:267:
undefined reference to `ns87312_enable_ide'
arch/alpha/kernel/built-in.o:/opt/scratch/groeck/linux-2.6/arch/alpha/kernel/sys_takara.c:267: more undefined references to `ns87312_enable_ide' follow

Not surprising since ns87312.c and thus ns87312_enable_ide() no longer
exist. The problem was introduced with commit
932e0c201d28a728e25d3b641aa95bd28ceb08b4 (alpha: Detect Super IO chip,
no IDE on Avanti, enable EPP19).

Guenter


