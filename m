Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182Ab1FPOIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 10:08:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:21132 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755253Ab1FPOIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 10:08:53 -0400
Message-Id: <d08817$d6fmn@azsmga001.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,375,1304319600"; 
   d="scan'208";a="13844183"
Date: Thu, 16 Jun 2011 15:08:48 +0100
To: Paul Rolland <rol@witbe.net>, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: Re: [3.0.0-rc3] GMBUS timed out
Cc: rol@witbe.net
References: <20110616154123.259414a3@tux.DEF.witbe.net>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20110616154123.259414a3@tux.DEF.witbe.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jun 2011 15:41:23 +0200, Paul Rolland (=?UTF-8?B?44Od44O844Or44O744Ot44Op44Oz?=)  <rol@witbe.net> wrote:
> Hello,
> 
> I've just booted 3.0.0-rc3 on my machine, and I got that message :
> Jun 16 15:32:07 tux kernel: [drm] GMBUS timed out, falling back to bit banging on pin 5 [i915 gmbus dpb]
> 
> I've checked my logs, and I never got that with my previous 2.6.39.1
> kernel, so that looks like something new to 3.x.

Attempting to use GMBUS when enabled for 3.0. It will have to be
disabled again until the GMBUS/GPIO adapter aligns better with the i2c
interface and doesn't cause a deadlock upon booting with the eeprom
module.

In the meantime, if you have the time and inclination, you can help by
working out under what conditions GMBUS fails. That info message is only
generated after we write a message over GMBUS and receive no response.
I've looked into one exchange that suggests that we may timeout if the
monitor is disconnected. Do you have anything connected to what would be
the first external output? Does the message go away if you boot with
that connected/disconnected?
 
> Should I report more details (and if so, which ones) or is that harmless
> (though I doubt kernel messages about a time out are harmless ;)

It's harmless in this case. Just a warning that the new hw driven method
failed and we are now using the old CPU driven method.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
