Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab0KAXrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 19:47:08 -0400
Received: from 34.97.116-78.rev.gaoland.net ([78.116.97.34]:39615 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752013Ab0KAXrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 19:47:00 -0400
Date: Tue, 2 Nov 2010 00:46:30 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.37-rc1, patch] r8169: fix sleeping while holding spinlock...
Message-ID: <20101101234630.GA12106@electric-eye.fr.zoreil.com>
References: <AANLkTimZvwdY8Q+=iGMC2MhPt_Vow38a0SE9g4ij-cRe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimZvwdY8Q+=iGMC2MhPt_Vow38a0SE9g4ij-cRe@mail.gmail.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel J Blueman <daniel.blueman@gmail.com> :
> Recent changes to the r8169 driver cause it to call
> device_set_wakeup_enable under spinlock, which may sleep.

The change is fine but the description is misleading : the r8169
driver has been issuing device_set_wakeup_enable under spinlock since
october 2008. device_set_wakeup_enable did not sleep until recently
(see f2dc0d1809ab7e0147c7e4ac837be1682f706538 for instance).

drivers/net/gianfar_ethtool.c::gfar_set_wol is broken as well when
CONFIG_PM is set.

-- 
Ueimor
