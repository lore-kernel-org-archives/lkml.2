Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab2FSFE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 01:04:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61344 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab2FSFE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 01:04:28 -0400
Date: Mon, 18 Jun 2012 22:02:36 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jenny TC <jenny.tc@intel.com>, Jean Delvare <khali@linux-fr.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Len Brown <len.brown@intel.com>
Subject: Re: linux-next: build warning after merge of the battery tree
Message-ID: <20120619050236.GA16286@lizard>
References: <20120619145408.4c68bff2ed75b52fdba66eff@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120619145408.4c68bff2ed75b52fdba66eff@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tue, Jun 19, 2012 at 02:54:08PM +1000, Stephen Rothwell wrote:
> After merging the battery tree, today's linux-next build (i386 defconfig)
> produced this warning:
> 
> drivers/power/power_supply_core.c: In function 'psy_register_thermal':
> drivers/power/power_supply_core.c:204:6: warning: passing argument 1 of 'thermal_zone_device_register' discards 'const' qualifier from pointer target type [enabled by default]
> include/linux/thermal.h:149:29: note: expected 'char *' but argument is of type 'const char *'
> 
> Introduced by commit 3be330bf8860 ("power_supply: Register battery as a
> thermal zone").

Yup, at the same time as I merged the thermal zone support for
power supply class, I also fixed the root cause of the warning:

http://lkml.org/lkml/2012/6/18/28

But I guess it will go via -mm tree. Or should/can I take it into
battery-2.6 tree? Added Cc's.

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
