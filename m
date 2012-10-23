Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475Ab2JWAUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 20:20:16 -0400
Received: from mga14.intel.com ([143.182.124.37]:5422 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932227Ab2JWAUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 20:20:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,632,1344236400"; 
   d="scan'208";a="159155626"
Date: Tue, 23 Oct 2012 08:20:11 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Daniel Hazelton <dshadowwolf@gmail.com>,
        David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com, drepper@gmail.com,
        paulmck@linux.vnet.ibm.com
Subject: Re: tools/vm build fails
Message-ID: <20121023002011.GA4864@localhost>
References: <5085DE38.6030906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5085DE38.6030906@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Mon, Oct 22, 2012 at 08:00:56PM -0400, Daniel Hazelton wrote:
> After doing any build in the kernel (last attempt was an
> allmodconfig) I've tried to build the 'vm' tool in tools/vm and the
> build fails - looks to be fallout from the uapi header work.
> 
> [madman@localhost tools]$ make V=1 vm
> make -C vm/
> make[1]: Entering directory `/home/madman/sources/linux-2.6/tools/vm'
> gcc -Wall -Wextra -o page-types page-types.c
> In file included from page-types.c:38:0:
> ../../include/linux/kernel-page-flags.h:4:42: fatal error:
> uapi/linux/kernel-page-flags.h: No such file or directory
> compilation terminated.
> make[1]: *** [page-types] Error 1
> make[1]: Leaving directory `/home/madman/sources/linux-2.6/tools/vm'
> make: *** [vm] Error 2

That must be related to:

commit 607ca46e97a1b6594b29647d98a32d545c24bdff
Author:     David Howells <dhowells@redhat.com>

    UAPI: (Scripted) Disintegrate include/linux


It should be trivially fixable in several ways, and David must know
the best way. :)

Thanks,
Fengguang
