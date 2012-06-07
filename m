Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab2FGMdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 08:33:44 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48655 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542Ab2FGMdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 08:33:42 -0400
Message-ID: <1339072491.3279.6.camel@lappy>
Subject: iwlwifi: kernel panic during boot due to module load order
From: Sasha Levin <levinsasha928@gmail.com>
To: donald.h.fry@intel.com, emmanuel.grumbach@intel.com,
        johannes.berg@intel.com, linville@tuxdriver.com,
        wey-yi.w.guy@intel.com
Cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 07 Jun 2012 14:34:51 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Commit cc5f7e397 ("iwlwifi: implement dynamic opmode loading") causes a
kernel panic during boot in the following scenario:

1. All drivers are built-in.
2. Due to their build order, iwl_init gets called before iwl_drv_init.
3. iwl_init will call iwl_opmode_register which will iterate the new op
list, and cause a NULL ptr deref when trying to list_for_each_entry the
dev list, which won't be empty since it wasn't initialized (iwl_drv_init
wasn't called yet).

While it's possible to easily fix the actual deref, I suspect that the
init function call order is wrong. I've looked at getting it right in
the Makefile, but it seems to have specific ordering behind it, so I'd
rather not try patching it myself.

Thanks,
Sasha.

