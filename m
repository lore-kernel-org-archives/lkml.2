Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab1JKStn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 14:49:43 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:60150 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755213Ab1JKStl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 14:49:41 -0400
Message-ID: <4E948FC3.2080801@xenotime.net>
Date: Tue, 11 Oct 2011 11:49:39 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>
Subject: Re: linux-next: Tree for Oct 11 (mmc)
References: <20111011201127.455df266dcbffb1d621f8576@canb.auug.org.au>
In-Reply-To: <20111011201127.455df266dcbffb1d621f8576@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/11 02:11, Stephen Rothwell wrote:
> Hi all,
> 
> The linux-next tree is now available from
> git://github.com/sfrothwell/linux-next.git as a temporary measure while
> the kernel.org servers are unavailable.
> 
> It may also turn up on git.kernel.org (depending on the mirroring).  The
> patch set is still absent, however.
> 
> Changes since 20111007:


When CONFIG_BLOCK is not enabled:

In file included from next-2011-1011/drivers/mmc/card/sdio_uart.c:43:0:
next-2011-1011/include/linux/mmc/card.h:175:12: error: 'DISK_NAME_LEN' undeclared here (not in a function)

Deleting the #include <linux/mmc/card.h> fixes the sdio_uart.c build.
However, the same problem occurs in mmc/core/core.c:

In file included from next-2011-1011/drivers/mmc/core/core.c:30:0:
next-2011-1011/include/linux/mmc/card.h:175:12: error: 'DISK_NAME_LEN' undeclared here (not in a function)

Should mmc/core/ depend on BLOCK?  or should it just be made
to build even when BLOCK is not enabled?

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
