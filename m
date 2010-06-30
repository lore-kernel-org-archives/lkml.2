Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab0F3Nfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 09:35:37 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:48691 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab0F3Nfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 09:35:36 -0400
Date: Wed, 30 Jun 2010 14:35:34 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jiri Kosina <jkosina@suse.cz>
cc: Ralf Baechle <ralf@linux-mips.org>, Christoph Egger <siccegge@cs.fau.de>,
       Gilles Espinasse <g.esp@free.fr>, Tejun Heo <tj@kernel.org>,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 3/9] Removing dead CONFIG_SIBYTE_BCM1480_PROF
In-Reply-To: <alpine.LNX.2.00.1006301133400.13809@pobox.suse.cz>
Message-ID: <alpine.LFD.2.00.1006301431210.13070@eddie.linux-mips.org>
References: <cover.1275925108.git.siccegge@cs.fau.de> <c217f4530c057f4b8030bd14459a0cb2856decde.1275925108.git.siccegge@cs.fau.de> <alpine.LNX.2.00.1006161800290.12271@pobox.suse.cz> <20100628134959.GC29229@linux-mips.org>
 <alpine.LNX.2.00.1006301133400.13809@pobox.suse.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jun 2010, Jiri Kosina wrote:

> Well, still it's dead code guarded by ifdef depending on non-exsiting 
> symbol ... I have just quickly tried to get a grip on the zbus thing, but

 You've missed...

> 	arch/mips/configs/bigsur_defconfig:CONFIG_SIBYTE_HAS_ZBUS_PROFILING=y
> 	arch/mips/configs/sb1250-swarm_defconfig:CONFIG_SIBYTE_HAS_ZBUS_PROFILING=y
> 	arch/mips/sibyte/Kconfig:       select SIBYTE_HAS_ZBUS_PROFILING
> 	arch/mips/sibyte/Kconfig:       select SIBYTE_HAS_ZBUS_PROFILING
> 	arch/mips/sibyte/Kconfig:       select SIBYTE_HAS_ZBUS_PROFILING
> 	arch/mips/sibyte/Kconfig:       select SIBYTE_HAS_ZBUS_PROFILING
> 	arch/mips/sibyte/Kconfig:       select SIBYTE_HAS_ZBUS_PROFILING
> 	arch/mips/sibyte/Kconfig:       select SIBYTE_HAS_ZBUS_PROFILING
> 	arch/mips/sibyte/Kconfig:       select SIBYTE_HAS_ZBUS_PROFILING

... this:

	arch/mips/sibyte/Kconfig:	config SIBYTE_TBPROF
	arch/mips/sibyte/Kconfig:	tristate "Support for ZBbus profiling"
> 	arch/mips/sibyte/Kconfig:       depends on SIBYTE_HAS_ZBUS_PROFILING

^^^ here.

> 	arch/mips/sibyte/Kconfig:config SIBYTE_HAS_ZBUS_PROFILING
> 
> seem to be the only occurences in the whole tree. Another unused symbol?

 Not quite so then.

  Maciej
