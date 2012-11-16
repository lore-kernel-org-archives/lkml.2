Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab2KPS0u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 13:26:50 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:40970 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685Ab2KPS0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 13:26:49 -0500
Date: Fri, 16 Nov 2012 13:26:43 -0500
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: sjenning@linux.vnet.ibm.com, dan.magenheimer@oracle.com,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ngupta@vflare.org, minchan@kernel.org,
        akpm@linux-foundation.org, mgorman@suse.de, fschmaus@gmail.com,
        andor.daam@googlemail.com, ilendir@googlemail.com
Subject: Re: [PATCH v2] enable all tmem backends to be built and loaded as
 modules.
Message-ID: <20121116182641.GA26424@phenom.dumpdata.com>
References: <1352920339-10183-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352920339-10183-1-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Um, that is what I get from doing this while traveling.

This is the writeup:

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] zcache2 cleanups (s/int/bool/ + debugfs move).
In-Reply-To: 
Changelog since rfc: https://lkml.org/lkml/2012/11/5/549
 - Added Reviewed-by from Dan.

This patchset depends on the recently posted V2 of making the
frontswap/cleancache backends be module capable:
 http://mid.gmane.org/1352919432-9699-1-git-send-email-konrad.wilk@oracle.com

I think that once the V2 is OK I will combine this patchset along
with the V2 and send the whole thing to GregKH? Or perhaps just
if Greg is Ok I will do via my tree.

This is a copy of what I wrote in the RFC posting:

Looking at the zcache2 code there were a couple of things that I thought
would make sense to move out of the code. For one thing it makes it easier
to read, and for anoter - it can be cleanly compiled out. It also allows
to have a clean seperation of counters that we _need_ vs the optional ones.
Which means that in the future we could get rid of the optional ones.

It fixes some outstanding compile warnings, cleans
up some of the code, and rips out the debug counters out of zcache-main.c
and sticks them in a debug.c file.

I was hoping it would end up with less code, but sadly it ended up with
a bit more due to the empty non-debug functions - but the code is easier
to read.


 drivers/staging/ramster/Kconfig       |    8 +
 drivers/staging/ramster/Makefile      |    1 +
 drivers/staging/ramster/debug.c       |   66 +++++++
 drivers/staging/ramster/debug.h       |  229 ++++++++++++++++++++++
 drivers/staging/ramster/zcache-main.c |  336 +++++++--------------------------
 5 files changed, 370 insertions(+), 270 deletions(-)


Konrad Rzeszutek Wilk (11):
      zcache: Provide accessory functions for counter increase
      zcache: Provide accessory functions for counter decrease.
      zcache: The last of the atomic reads has now an accessory function.
      zcache: Fix compile warnings due to usage of debugfs_create_size_t
      zcache: Make the debug code use pr_debug
      zcache: Move debugfs code out of zcache-main.c file.
      zcache: Use an array to initialize/use debugfs attributes.
      zcache: Move the last of the debugfs counters out
      zcache: Allow to compile if ZCACHE_DEBUG and !DEBUG_FS
      zcache: Module license is defined twice.
      zcache: Coalesce all debug under CONFIG_ZCACHE2_DEBUG
