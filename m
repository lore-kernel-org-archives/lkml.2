Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab2K1LCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 06:02:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591Ab2K1LCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 06:02:19 -0500
Date: Wed, 28 Nov 2012 12:02:00 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: linux-next: build failure after merge of the modules tree
Message-ID: <20121128110145.GA3701@redhat.com>
References: <20121126151046.1b5b09762b8361b1f202c6e2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121126151046.1b5b09762b8361b1f202c6e2@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 03:10:46PM +1100, Stephen Rothwell wrote:
> After merging the modules tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/net/wireless/iwlwifi/iwl-drv.c:1196:1: error: invalid suffix "n_disabletype__8" on integer constant
> drivers/net/wireless/iwlwifi/iwl-drv.c:1196:1: error: expected identifier or '(' before numeric constant
> drivers/net/wireless/iwlwifi/iwl-drv.c:1198:1: error: invalid suffix "n_disable__9" on integer constant
> drivers/net/wireless/iwlwifi/iwl-drv.c:1198:1: error: expected identifier or '(' before numeric constant
> drivers/net/wireless/iwlwifi/iwl-drv.c:1263:1: error: invalid suffix "ghz_disabletype__32" on integer constant
> drivers/net/wireless/iwlwifi/iwl-drv.c:1263:1: error: expected identifier or '(' before numeric constant
> drivers/net/wireless/iwlwifi/iwl-drv.c:1264:1: error: invalid suffix "ghz_disable__33" on integer constant
> drivers/net/wireless/iwlwifi/iwl-drv.c:1264:1: error: expected identifier or '(' before numeric constant
> drivers/net/wireless/iwlegacy/4965-mac.c:6825:1: error: invalid suffix "n_disabletype__11" on integer constant
> drivers/net/wireless/iwlegacy/4965-mac.c:6825:1: error: expected identifier or '(' before numeric constant
> drivers/net/wireless/iwlegacy/4965-mac.c:6826:1: error: invalid suffix "n_disable__12" on integer constant
> drivers/net/wireless/iwlegacy/4965-mac.c:6826:1: error: expected identifier or '(' before numeric constant
> 
> Presumably caused by commit 58876af0436e ("moduleparam: use __UNIQUE_ID
> ()").  This commit removed the "__mod_" prefix that used to be added to
> the front of the "name" passed to module_param_named().  Admittedly, the
> documentation says that "name" must be "a valid C identifier which is the
> parameter name", but the (ab)usage here used to work (the name starts
> with a number).

I prefer not to change module parameters name, since there are users
who use current name in they modprobe config.

Stanislaw

