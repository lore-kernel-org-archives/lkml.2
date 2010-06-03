Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab0FCHT6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 03:19:58 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:16081 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808Ab0FCHTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 03:19:55 -0400
Authentication-Results: sj-iport-3.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAH70BkyrR7Hu/2dsb2JhbACeKHGlKJoDhRYEg0g
X-IronPort-AV: E=Sophos;i="4.53,352,1272844800"; 
   d="scan'208";a="225174736"
User-Agent: Microsoft-Entourage/12.24.0.100205
Date: Thu, 03 Jun 2010 00:19:53 -0700
Subject: Re: [net-next PATCH] drivers/net/enic: Use (pr|netdev)_<level> macro
 helpers
From: Scott Feldman <scofeldm@cisco.com>
To: Joe Perches <joe@perches.com>
CC: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Message-ID: <C82CA5A9.3677A%scofeldm@cisco.com>
Thread-Topic: [net-next PATCH] drivers/net/enic: Use (pr|netdev)_<level> macro
 helpers
Thread-Index: AcsC7SkVCv9NUkQR8EO3BY1X6/nK1A==
In-Reply-To: <1275492616.2489.20.camel@Joe-Laptop.home>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-OriginalArrivalTime: 03 Jun 2010 07:19:54.0853 (UTC) FILETIME=[2A30B150:01CB02ED]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/2/10 8:30 AM, "Joe Perches" <joe@perches.com> wrote:

> Compile tested only
> 
> Add #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> Remove #define PFX
> Use pr_<level>
> Use netdev_<level>
> Remove trailing periods from most formats
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Thanks Joe.  I tested it and there are a couple places before the netdev is
registered where we need dev_<level> rather than netdev_<level>, otherwise
we get output like:

enic 0000:08:00.0: (unregistered net_device): vNIC MAC addr
00:25:b5:19:35:8f wq/rq 256/512

I like the dev_name(dev) in there but not the "(unregister net_device)".

Also there where a couple of lines longer than 80 chars.

We can fix up the patch and resubmit if you like.

-scott

