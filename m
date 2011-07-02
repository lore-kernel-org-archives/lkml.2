Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab1GBJZW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 05:25:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:49958 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab1GBJZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 05:25:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH v2 0/6] ARM: make mach/hardware.h optional
Date: Sat, 2 Jul 2011 11:24:46 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>, nico@fluxnic.net,
        Rob Herring <rob.herring@calxeda.com>
References: <1309366019-24379-1-git-send-email-robherring2@gmail.com>
In-Reply-To: <1309366019-24379-1-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107021124.46953.arnd@arndb.de>
X-Provags-ID: V02:K0:96JE/CtzeOYKudAXWl6pBZAAWFw4O2D1Pkh15za1HfX
 FKZFl7jf+/++YAo5aqOPkMf2FH6yYA36GqNz/dqJTP9ZJQZuuX
 LxTKOr9R0dypl6pONJe8xYzhi7/fqjiD7E4IT19X9pfI3u/3c+
 2fLPuEAFoRr2zachll+S/YtkHnC8fPQNeiyA7RdhNucdB2Wipw
 g+tgljEnApmp2s6VDx4TA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 June 2011 18:46:53 Rob Herring wrote:
> 
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Currently, all ARM platforms must have a mach/hardware.h include. This is
> because it is ultimately included by linux/pci.h which is included in many
> places even for !CONFIG_PCI.
> 
> This could be fixed simply with an ifdef around the include of mach/hardware.h
> in asm/pci.h. However, in the interest of fixing this for single kernel
> binary builds, this series removes the include of mach/hardware.h outside of
> mach-* and plat-*. What's used from hardware.h is a couple of PCI defines. 
> Converting them to variables allows each platform to set the values as needed.
> 
> This does not address the inclusion of mach/hardware.h under drivers/*. This
> appears to be mostly older platforms. There could also be some indirect
> inclusions from other mach/* headers.
> 

Hi Rob,

This is very good work, I really like it. I've mentioned one idea for
an improvement in patch 5, which you can still integrate, but otherwise

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

for the whole series.

Thanks,

	Arnd
