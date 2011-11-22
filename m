Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab1KVIBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 03:01:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755520Ab1KVIBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 03:01:03 -0500
Date: Tue, 22 Nov 2011 09:03:16 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the wireless-next tree
Message-ID: <20111122080315.GD2199@redhat.com>
References: <20111122143523.ee83308efc48baf19f691441@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111122143523.ee83308efc48baf19f691441@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 02:35:23PM +1100, Stephen Rothwell wrote:
> After merging the wireless-next tree, today's linux-next build
> (x86_64_allmodconfig) failed like this:
> 
> ERROR: "il_dbgfs_unregister" [drivers/net/wireless/iwlegacy/iwl4965.ko] undefined!
> ERROR: "il_dbgfs_register" [drivers/net/wireless/iwlegacy/iwl4965.ko] undefined!
> ERROR: "il_dbgfs_unregister" [drivers/net/wireless/iwlegacy/iwl3945.ko] undefined!
> ERROR: "il_dbgfs_register" [drivers/net/wireless/iwlegacy/iwl3945.ko] undefined!

That is consequence of lack export.h in drivers/net/wireless/iwegacy/debug.c
and previous warnings:

drivers/net/wireless/iwlegacy/debug.c:1395:1: warning: data definition has no type or storage class [enabled by default]
drivers/net/wireless/iwlegacy/debug.c:1395:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]

Patch posted to fix warnings, should fix that build failure too.
Stanislaw
