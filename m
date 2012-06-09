Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab2FII3R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 04:29:17 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:57997 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab2FII3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 04:29:13 -0400
Message-ID: <1339230544.4539.21.camel@jlt3.sipsolutions.net>
Subject: Re: iwlwifi: kernel panic during boot due to module load order
From: Johannes Berg <johannes@sipsolutions.net>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: donald.h.fry@intel.com, emmanuel.grumbach@intel.com,
        linville@tuxdriver.com, wey-yi.w.guy@intel.com, ilw@linux.intel.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 09 Jun 2012 10:29:04 +0200
In-Reply-To: <1339072491.3279.6.camel@lappy> (sfid-20120607_143403_120928_12961A9D)
References: <1339072491.3279.6.camel@lappy>
	 (sfid-20120607_143403_120928_12961A9D)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-07 at 14:34 +0200, Sasha Levin wrote:
> Hi all,
> 
> Commit cc5f7e397 ("iwlwifi: implement dynamic opmode loading") causes a
> kernel panic during boot in the following scenario:
> 
> 1. All drivers are built-in.
> 2. Due to their build order, iwl_init gets called before iwl_drv_init.
> 3. iwl_init will call iwl_opmode_register which will iterate the new op
> list, and cause a NULL ptr deref when trying to list_for_each_entry the
> dev list, which won't be empty since it wasn't initialized (iwl_drv_init
> wasn't called yet).
> 
> While it's possible to easily fix the actual deref, I suspect that the
> init function call order is wrong. I've looked at getting it right in
> the Makefile, but it seems to have specific ordering behind it, so I'd
> rather not try patching it myself.

Yeah, looks like we forgot about this part.

I think Don said he had a fix, my suggestion would be to try to just
reorder the dvm line in the iwlwifi/Makefile to the bottom of the
Makefile, or at least after obj-$(...) += iwlwifi.o.

johannes

