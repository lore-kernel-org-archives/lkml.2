Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab1FJPgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 11:36:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60133 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab1FJPgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 11:36:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH 7/7] [v4] drivers/virt: introduce Freescale hypervisor management driver
Date: Fri, 10 Jun 2011 17:36:14 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linuxppc-dev@lists.ozlabs.org,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Timur Tabi <timur@freescale.com>, konrad.wilk@oracle.com,
        kumar.gala@freescale.com, linux-kernel@vger.kernel.org,
        akpm@kernel.org, dsaxena@linaro.org, linux-console@vger.kernel.org,
        greg@kroah.com, alan@lxorguk.ukuu.org.uk
References: <1307573154-15838-1-git-send-email-timur@freescale.com> <201106090938.23027.arnd@arndb.de> <4DF22770.4010103@tilera.com>
In-Reply-To: <4DF22770.4010103@tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106101736.14850.arnd@arndb.de>
X-Provags-ID: V02:K0:c9r/ttdSad43LwMpb/K16hdPHbf7OgQHlk2lHJuzTzC
 H3FkamlVhKerokjzjQFSiVMINGMz6jRp7VGijud+2YZj++Qnvs
 tndv84tf/ttKP44T/u8up7ugZbU8cESQgXnLCfre/O0W+08GFK
 5rODgYL4j+1nStGuOa/ESyMJIZvSbJ2YhiNCMbf98YNO7SuTDw
 gghbINHZ0dt5lOhEXvefQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 June 2011, Chris Metcalf wrote:
> This still leaves open the question of what really should go in this new
> directory. Is it just for drivers that manage/control the hypervisor?  Or
> is it also for drivers that just use the hypervisor to do I/O of some kind,
> but aren't related to any other "family" of drivers, i.e., a driver that
> would have been dumped in drivers/char or drivers/misc in the old days?
> 
> My specific interest at the moment is the proposed tile-srom.c driver
> (https://patchwork.kernel.org/patch/843892/), which uses a simple
> hypervisor read/write API to access the portion of the SPI ROM used to hold
> the boot stream for a TILE processor.

I'd still put that driver in drivers/char for now, because it already contains
similar drivers. We can probaby group them in a subdirectory of drivers/char
at some point or move them out to a new directory.

For your raw hcall passthrough driver, that would be something that should
go into drivers/virt/ IMHO.

	Arnd
