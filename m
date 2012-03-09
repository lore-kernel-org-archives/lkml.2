Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987Ab2CIVOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 16:14:41 -0500
Received: from usmamail.tilera.com ([206.83.70.75]:25091 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149Ab2CIVOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 16:14:39 -0500
Message-ID: <4F5A72BC.6090707@tilera.com>
Date: Fri, 9 Mar 2012 16:14:36 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: <paul.gortmaker@windriver.com>, <hpa@zytor.com>,
        <torvalds@linux-foundation.org>, <sfr@canb.auug.org.au>,
        <mingo@redhat.com>, <arnd@arndb.de>, <tglx@linutronix.de>,
        <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 26/29] Disintegrate asm/system.h for Tile
References: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk> <20120307195046.15987.91414.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120307195046.15987.91414.stgit@warthog.procyon.org.uk>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/2012 2:56 PM, David Howells wrote:
> Disintegrate asm/system.h for Tile.  Not compiled.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  arch/tile/include/asm/barrier.h    |  140 +++++++++++++++++++
>  arch/tile/include/asm/cacheflush.h |   10 +
>  arch/tile/include/asm/exec.h       |   20 +++
>  arch/tile/include/asm/setup.h      |   21 +++
>  arch/tile/include/asm/switch_to.h  |   72 ++++++++++
>  arch/tile/include/asm/system.h     |  261 ------------------------------------
>  arch/tile/include/asm/timex.h      |    2 
>  arch/tile/include/asm/unaligned.h  |   15 ++

This looks approximately correct.  I suspect there may be a few functions
that need to be moved around, or #includes added: for example some of the
<asm/setup.h> functions are invoked from the scheduler, like
arch_set_cpus_allowed() and hardwall_deactivate().

If you have a tree I can pull I'm happy to test it out.

Please cc me on any other tile-specific changes to make sure I see them.
Thanks!
-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com
