Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423504Ab2LFNAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 08:00:00 -0500
Received: from [206.117.179.246] ([206.117.179.246]:42272 "EHLO labridge.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755010Ab2LFM77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 07:59:59 -0500
Message-ID: <1354798778.17565.8.camel@joe-AO722>
Subject: Re: [PATCH v2 12/44] metag: TBX source
From: Joe Perches <joe@perches.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Date: Thu, 06 Dec 2012 04:59:38 -0800
In-Reply-To: <50C066D9.9010700@imgtec.com>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
	 <1354723742-6195-13-git-send-email-james.hogan@imgtec.com>
	 <1354733607.8320.3.camel@joe-AO722> <50C066D9.9010700@imgtec.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-06 at 09:35 +0000, James Hogan wrote:
> On 05/12/12 18:53, Joe Perches wrote:
> > On Wed, 2012-12-05 at 16:08 +0000, James Hogan wrote:
> >> Add source files from the Thread Binary Interface (TBI) library which
> >> provides useful low level operations and traps/context management.
> > []
> >>  arch/metag/tbx/tbicache.c  |  462 ++++++++++++++++++++++++++++++++++++++++++++
> > 
> > Could you please run checkpatch on this file?
> 
> Hi Joe,
> 
> Thanks for taking a look.
> 
> I'd prefer to avoid making style modifications to the tbx/ files if
> possible to ease maintenance, as the code is shared with other projects
> and maintained by a separate group.
> 
> Of course if cleaning up the style is deemed absolutely necessary then
> so be it.

Your choice though the file looks to me to be linux
specific as it uses #include <linux/stddef.h>

Also, two functions, __TBIDataCacheFlush and
__TBICodeCacheFlush, have an unnecessary indentation
level after a test and return.

void __TBICodeCacheFlush( const void *pStart, int Bytes )
{
	volatile int *pCtrl = (volatile int *) SYSC_CACHE_MMU_CONFIG;

	if ( !__TBICacheDoneInit )
		__TBICacheInit();

	if ( (pCtrl[0] & SYSC_CMMUCFG_IC_ON_BIT) == 0 )
	{
		/* No need to flush the code cache it's not actually enabled */
		return;
	} 

	{
		/* Use a sequence of writes to flush the cache region requested */	
		int Loops, Step;

		etc.

I believe the automatics in the second blocks should
be moved to the start of the function and the
unnecessary braces and extra indentation removed.

