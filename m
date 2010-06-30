Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab0F3Jg7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 05:36:59 -0400
Received: from cantor.suse.de ([195.135.220.2]:54120 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896Ab0F3Jg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 05:36:58 -0400
Date: Wed, 30 Jun 2010 11:36:53 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Christoph Egger <siccegge@cs.fau.de>, Gilles Espinasse <g.esp@free.fr>,
       Tejun Heo <tj@kernel.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 3/9] Removing dead CONFIG_SIBYTE_BCM1480_PROF
In-Reply-To: <20100628134959.GC29229@linux-mips.org>
Message-ID: <alpine.LNX.2.00.1006301133400.13809@pobox.suse.cz>
References: <cover.1275925108.git.siccegge@cs.fau.de> <c217f4530c057f4b8030bd14459a0cb2856decde.1275925108.git.siccegge@cs.fau.de> <alpine.LNX.2.00.1006161800290.12271@pobox.suse.cz> <20100628134959.GC29229@linux-mips.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jun 2010, Ralf Baechle wrote:

> > > CONFIG_SIBYTE_BCM1480_PROF doesn't exist in Kconfig, therefore removing all
> > > references for it from the source code.
> > 
> > The patch isn't present in linux-next as of today. I have applied it to my 
> > tree, thanks.
> 
> Nack.  This only need to be rewired to use the ZBus profiler just like
> the SB1250 already does.  It's the virtually same hardware after all!

Well, still it's dead code guarded by ifdef depending on non-exsiting 
symbol ... I have just quickly tried to get a grip on the zbus thing, but

	arch/mips/configs/bigsur_defconfig:CONFIG_SIBYTE_HAS_ZBUS_PROFILING=y
	arch/mips/configs/sb1250-swarm_defconfig:CONFIG_SIBYTE_HAS_ZBUS_PROFILING=y
	1arch/mips/sibyte/Kconfig:       select SIBYTE_HAS_ZBUS_PROFILING
	arch/mips/sibyte/Kconfig:       select SIBYTE_HAS_ZBUS_PROFILING
	arch/mips/sibyte/Kconfig:       select SIBYTE_HAS_ZBUS_PROFILING
	arch/mips/sibyte/Kconfig:       select SIBYTE_HAS_ZBUS_PROFILING
	arch/mips/sibyte/Kconfig:       select SIBYTE_HAS_ZBUS_PROFILING
	arch/mips/sibyte/Kconfig:       select SIBYTE_HAS_ZBUS_PROFILING
	arch/mips/sibyte/Kconfig:       select SIBYTE_HAS_ZBUS_PROFILING
	arch/mips/sibyte/Kconfig:       depends on SIBYTE_HAS_ZBUS_PROFILING
	arch/mips/sibyte/Kconfig:config SIBYTE_HAS_ZBUS_PROFILING

seem to be the only occurences in the whole tree. Another unused symbol?

So I'll revert that patch in my tree as it has been nacked by maintainer, 
but the feeling that cleanup is needed is still there.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
