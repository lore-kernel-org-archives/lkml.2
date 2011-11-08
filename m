Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab1KHJL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 04:11:57 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:40779 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab1KHJLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 04:11:54 -0500
Date: Tue, 8 Nov 2011 10:07:16 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] r8169: increase the delay parameter of pm_schedule_suspend
Message-ID: <20111108090716.GA4885@electric-eye.fr.zoreil.com>
References: <1320734677-1372-1-git-send-email-hayeswang@realtek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320734677-1372-1-git-send-email-hayeswang@realtek.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hayes Wang <hayeswang@realtek.com> :
> The link down would occur when reseting PHY. And it would take about 2 ~ 5 seconds
> from link down to link up. If the delay of pm_schedule_suspend is not long enough,
> the device would enter runtime_suspend before link up. After link up, the device
> would wake up and reset PHY again. Then, you would find the driver keep in a loop
> of runtime_suspend and rumtime_resume.

Acked-by: Francois Romieu <romieu@fr.zoreil.com>

So far the worst offender here is the 8111evl (RTL_GIGA_MAC_VER_34) with a
max delay a bit below 4000 ms.

[...]
[ 4195.444121] r8169 0000:03:00.0: 8111e-vl-0: link up
[ 4195.549396] r8169 0000:03:00.0: 8111e-vl-0: link down
[ 4195.888002] r8169 0000:03:00.0: 8111e-vl-0: link up
[ 4199.444120] r8169 0000:03:00.0: 8111e-vl-0: link up
[ 4199.582073] r8169 0000:03:00.0: 8111e-vl-0: link down

[...]
[ 4171.580422] r8169 0000:03:00.0: 8111e-vl-0: link down
[ 4171.904002] r8169 0000:03:00.0: 8111e-vl-0: link up
[ 4175.444131] r8169 0000:03:00.0: 8111e-vl-0: link up
[ 4175.547453] r8169 0000:03:00.0: 8111e-vl-0: link down

The 8168d-vb-gr (RTL_GIGA_MAC_VER_26) and the 8168b (RTL_GIGA_MAC_VER_12)
worked out of the box without the patch - at least with a kernel including
Rafael's recent changes - and the old PCI 8169 always worked.

I have not tested the 8168f nor the 810x yet.

Increasing the delay over and over in the driver alone will not ensure
that the system is always stable but it should send the stuff on a far
enough orbit for some time.

-- 
Ueimor
